import { readFileSync } from 'node:fs';
import { resolve, sep } from 'node:path';

/** 讀取 lean-examples 中的 canonical 原始檔；有 region 時只取 ANCHOR 區段。 */
export function readLeanSource(file: string, region?: string): string {
  const root = resolve(process.cwd(), 'lean-examples');
  const path = resolve(root, file);
  if (!path.startsWith(root + sep) || !file.endsWith('.lean')) throw new Error(`Invalid Lean source: ${file}`);
  let code = readFileSync(path, 'utf8');
  if (region) {
    const start = `-- ANCHOR: ${region}`;
    const end = `-- ANCHOR_END: ${region}`;
    const lines = code.split('\n');
    const from = lines.findIndex(line => line.trim() === start);
    const to = lines.findIndex((line, i) => i > from && line.trim() === end);
    if (from < 0 || to < 0) throw new Error(`Missing Lean region ${file}:${region}`);
    code = lines.slice(from + 1, to).join('\n');
  } else {
    code = code.split('\n').filter(line => !/^\s*-- ANCHOR(?:_END)?:/.test(line)).join('\n');
  }
  return code.trimEnd();
}

/** 依 "3" 或 "3-5"（1 起算、含端點）取出區段中的行；超出範圍時讓建置失敗。 */
export function pickLines(code: string, range: string, label: string): string {
  const lines = code.split('\n');
  const m = /^(\d+)(?:-(\d+))?$/.exec(range.trim());
  if (!m) throw new Error(`Bad line range "${range}" in ${label}`);
  const a = Number(m[1]);
  const b = Number(m[2] ?? m[1]);
  if (a < 1 || b < a || b > lines.length) throw new Error(`Line range "${range}" outside ${label} (${lines.length} lines)`);
  return lines.slice(a - 1, b).join('\n');
}
