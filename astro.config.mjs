import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import remarkMath from 'remark-math';
import rehypeKatex from 'rehype-katex';
import { unified } from '@astrojs/markdown-remark';

export default defineConfig({
  site: process.env.SITE_URL || undefined,
  base: process.env.BASE_PATH || '/',
  trailingSlash: 'always',
  markdown: { processor: unified({ remarkPlugins: [remarkMath], rehypePlugins: [rehypeKatex] }) },
  integrations: [starlight({
    title: 'Lean × AI',
    description: '給大學生與研究生的 Lean 4 自學教材：從數學想法到可檢查的證明。',
    defaultLocale: 'root',
    locales: { root: { label: '繁體中文', lang: 'zh-TW' } },
    customCss: ['./src/styles/course.css'],
    components: { Hero: './src/components/Hero.astro' },
    sidebar: [
      { label: '學習起點', items: [{ label: '課程首頁', slug: '' }, { label: '準備實作環境', slug: 'guides/setup' }] },
      { label: '八章主線', items: [{ autogenerate: { directory: 'chapters' } }] },
      { label: '三個完整實戰', items: [{ autogenerate: { directory: 'labs' } }] },
      { label: '進階範例', items: [{ autogenerate: { directory: 'advanced' } }] },
      { label: '參考教材與影片', slug: 'guides/resources' },
    ],
    tableOfContents: { minHeadingLevel: 2, maxHeadingLevel: 3 },
    pagination: true,
    editLink: { baseUrl: undefined },
    expressiveCode: { themes: ['github-light', 'github-dark'] },
  })],
});
