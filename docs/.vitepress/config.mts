import { defineConfig } from 'vitepress'

const repository = 'https://github.com/Sunwood-ai-labs/delegate-to-grok-skill'

export default defineConfig({
  title: 'delegate-to-grok',
  description: 'A Codex delegation lane for Grok Build research, review, comparison, and implementation support on Windows.',
  base: '/delegate-to-grok-skill/',
  head: [
    ['link', { rel: 'icon', type: 'image/svg+xml', href: '/icon.svg' }],
    ['meta', { name: 'theme-color', content: '#2563eb' }]
  ],
  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
      themeConfig: {
    logo: '/icon.svg',
    siteTitle: 'delegate-to-grok',
    nav: [
      { text: 'Get started', link: '/guide/getting-started' },
      { text: 'Delegation contract', link: '/guide/safe-delegation' },
      { text: 'Release notes', link: '/releases/v0.1.0' },
      { text: '日本語', link: '/ja/' },
      { text: 'GitHub', link: repository }
    ],
    sidebar: {
      '/guide/': [
        { text: 'Delegation guide', items: [
          { text: 'Getting started', link: '/guide/getting-started' },
          { text: 'Delegation contract', link: '/guide/safe-delegation' },
          { text: 'Troubleshooting', link: '/guide/troubleshooting' }
        ] }
      ],
      '/releases/': [
        { text: 'Release notes', items: [{ text: 'v0.1.0', link: '/releases/v0.1.0' }] }
      ],
    },
    socialLinks: [{ icon: 'github', link: repository }],
    footer: { message: 'Released under the MIT License.', copyright: 'Copyright © 2026 Sunwood-ai-labs' },
    search: { provider: 'local' }
      }
    },
    ja: {
      label: '日本語',
      lang: 'ja-JP',
      link: '/ja/',
      themeConfig: {
        logo: '/icon.svg',
        siteTitle: 'delegate-to-grok',
        nav: [
          { text: 'はじめる', link: '/ja/guide/getting-started' },
          { text: '実行契約', link: '/ja/guide/safe-delegation' },
          { text: 'リリースノート', link: '/ja/releases/v0.1.0' },
          { text: 'English', link: '/' },
          { text: 'GitHub', link: repository }
        ],
        sidebar: {
          '/ja/guide/': [
            { text: 'ガイド', items: [
              { text: 'はじめに', link: '/ja/guide/getting-started' },
              { text: '実行契約', link: '/ja/guide/safe-delegation' },
              { text: 'トラブルシューティング', link: '/ja/guide/troubleshooting' }
            ] }
          ],
          '/ja/releases/': [
            { text: 'リリースノート', items: [{ text: 'v0.1.0', link: '/ja/releases/v0.1.0' }] }
          ]
        },
        socialLinks: [{ icon: 'github', link: repository }],
        footer: { message: 'MIT ライセンスで公開しています。', copyright: 'Copyright © 2026 Sunwood-ai-labs' },
        search: { provider: 'local' }
      }
    }
  }
})
