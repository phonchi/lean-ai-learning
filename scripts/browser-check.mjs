import { chromium } from '@playwright/test';
import { mkdir, writeFile, readdir } from 'node:fs/promises';
import { resolve } from 'node:path';

const origin = (process.env.PREVIEW_URL || 'http://127.0.0.1:4321').replace(/\/$/, '');
const output = resolve(process.env.BROWSER_OUTPUT || 'verification/browser');
await mkdir(resolve(output, 'screenshots'), { recursive: true });
const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({ viewport: { width: 1440, height: 900 }, locale: 'zh-TW', colorScheme: 'light', permissions: ['clipboard-read', 'clipboard-write'], reducedMotion: 'reduce' });
const page = await context.newPage();
const errors = [];
page.on('pageerror', error => errors.push(String(error)));
page.on('console', message => { if (message.type() === 'error') errors.push(message.text()); });
const checks = [];
function check(name, condition, details = '') { checks.push({ name, passed: Boolean(condition), details }); if (!condition) throw new Error(name + ': ' + details); }
async function visit(route) {
 const response = await page.goto(origin + route, { waitUntil: 'networkidle' });
 check('載入 ' + route, response?.status() === 200, String(response?.status()));
 check('繁體中文語系 ' + route, (await page.locator('html').getAttribute('lang'))?.toLowerCase() === 'zh-tw');
 check('唯一非空主標題 ' + route, (await page.locator('main h1').count()) === 1 && (await page.locator('main h1').innerText()).trim().length > 0);
}
try {
 const routes = ['/'];
 for (const dir of ['chapters', 'labs', 'advanced', 'guides']) {
  for (const file of (await readdir('src/content/docs/' + dir)).filter(n => /\.mdx?$/.test(n)).sort()) routes.push('/' + dir + '/' + file.replace(/\.mdx?$/, '') + '/');
 }
 check('完整教材頁數', routes.length === 17, String(routes.length));
 const links = new Set();
 for (const route of routes) {
  await visit(route);
  const discovered = await page.locator('a[href]').evaluateAll(as => as.map(a => a.href));
  for (const href of discovered) if (new URL(href).origin === new URL(origin).origin) links.add(href.split('#')[0]);
 }
 for (const href of links) {
  const prefix = new URL(origin).pathname.replace(/\/$/, '');
  const pathname = new URL(href).pathname;
  check('站內連結保留發布子路徑 ' + pathname, !prefix || pathname === prefix || pathname.startsWith(prefix + '/'));
  const response = await context.request.get(href);
  check('站內連結 ' + new URL(href).pathname, response.status() === 200, String(response.status()));
 }
 for (const viewport of [{width:390,height:844}, {width:768,height:1024}, {width:1280,height:720}, {width:1440,height:900}]) {
  await page.setViewportSize(viewport);
  for (const [label, route] of [['home','/'], ['chapter','/chapters/01-first-proof/'], ['lab','/labs/03-sum-of-squares/']]) {
   await visit(route);
   await page.evaluate(() => document.fonts.ready);
   const layout = await page.evaluate(() => ({ width: document.documentElement.clientWidth, scroll: document.documentElement.scrollWidth }));
   check('無頁面水平溢出 ' + label + ' ' + viewport.width, layout.scroll <= layout.width + 1, JSON.stringify(layout));
   await page.screenshot({ path: resolve(output, 'screenshots', label + '-' + viewport.width + '.png'), fullPage: true });
  }
 }
 await page.setViewportSize({width:1440,height:900});
 await visit('/');
 for (let i=0;i<4;i++) await page.locator('[data-proof-next]').click();
 check('證明逐步推演完成', (await page.locator('[data-proof-goal]').innerText()) === '沒有剩餘目標');
 check('最後一步停用前進', await page.locator('[data-proof-next]').isDisabled());
 await page.locator('[data-proof-prev]').click();
 check('證明可回上一步', (await page.locator('[data-proof-goal]').innerText()).includes('⊢ P'));
 await visit('/chapters/01-first-proof/');
 const copy = page.locator('[data-lean-copy]').first();
 const expected = await copy.getAttribute('data-code');
 await copy.click();
 const copied = await page.evaluate(() => navigator.clipboard.readText());
 check('複製 canonical Lean 程式碼', copied === expected);
 const details = page.locator('main details').first();
 check('練習有可展開提示', await details.count() === 1);
 await details.locator('summary').click();
 check('提示可展開', await details.getAttribute('open') !== null);
 await page.locator('site-search [data-open-modal]').click();
 await page.locator('.pagefind-ui__search-input').fill('歸納');
 await page.waitForFunction(() => document.querySelectorAll('.pagefind-ui__result').length > 0, { timeout: 15000 });
 check('繁體中文全文搜尋', await page.locator('.pagefind-ui__result').count() > 0);
 await page.keyboard.press('Escape');
 check('搜尋可用 Escape 關閉', !(await page.locator('site-search dialog').evaluate(d => d.open)));
 await page.getByRole('combobox').selectOption('dark');
 check('深色模式', await page.locator('html').getAttribute('data-theme') === 'dark');
 await page.screenshot({path:resolve(output,'screenshots/chapter-dark.png'),fullPage:true});
 await page.getByRole('combobox').selectOption('light');
 await page.setViewportSize({width:390,height:844});
 const menu = page.locator('button[popovertarget="starlight__sidebar"]');
 await menu.click();
 check('手機選單可開啟', await page.locator('#starlight__sidebar').evaluate(el => el.matches(':popover-open')));
 await menu.click();
 check('手機選單可關閉', !(await page.locator('#starlight__sidebar').evaluate(el => el.matches(':popover-open'))));
 const zip = await context.request.get(origin + '/downloads/lean-ai-examples.zip');
 check('下載檔案具有 ZIP 標頭', (await zip.body()).subarray(0,2).toString() === 'PK');
 check('無瀏覽器執行錯誤', errors.length === 0, errors.join('\n'));
} catch (error) {
 checks.push({ name: '驗證程序', passed: false, details: String(error) });
 console.error(error);
} finally {
 const result = { origin, browser: browser.version(), checkedAt: new Date().toISOString(), checks, errors, passed: checks.every(c=>c.passed) };
 await writeFile(resolve(output,'results.json'), JSON.stringify(result,null,2));
 await browser.close();
 console.log(JSON.stringify({passed:result.passed,checks:checks.length,failed:checks.filter(c=>!c.passed)},null,2));
 if (!result.passed) process.exitCode = 1;
}
