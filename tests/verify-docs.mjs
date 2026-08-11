import { existsSync, readFileSync } from 'node:fs'
import { resolve } from 'node:path'

const repoRoot = resolve(import.meta.dirname, '..')
const docsRoot = resolve(repoRoot, 'docs')
const requiredFiles = [
  '.vitepress/config.mts',
  '.vitepress/theme/index.ts',
  '.vitepress/theme/style.css',
  'public/icon.svg',
  'index.md',
  'guide/getting-started.md',
  'guide/safe-delegation.md',
  'guide/troubleshooting.md',
  'releases/v0.1.0.md',
  'ja/index.md',
  'ja/guide/getting-started.md',
  'ja/guide/safe-delegation.md',
  'ja/guide/troubleshooting.md',
  'ja/releases/v0.1.0.md',
  '.vitepress/dist/index.html',
  '.vitepress/dist/ja/index.html',
  '.vitepress/dist/guide/getting-started.html',
  '.vitepress/dist/ja/guide/getting-started.html'
]

for (const relativePath of requiredFiles) {
  if (!existsSync(resolve(docsRoot, relativePath))) {
    throw new Error(`Missing required docs artifact: docs/${relativePath}`)
  }
}

const config = readFileSync(resolve(docsRoot, '.vitepress/config.mts'), 'utf8')
for (const expected of ["base: '/delegate-to-grok-skill/'", "logo: '/icon.svg'", "link: '/ja/'", "text: 'English'"]) {
  if (!config.includes(expected)) throw new Error(`VitePress config is missing: ${expected}`)
}

const icon = readFileSync(resolve(docsRoot, 'public/icon.svg'), 'utf8')
if (!icon.includes('<svg') || !icon.includes('Delegate to Grok safety route')) {
  throw new Error('The shared icon SVG is incomplete.')
}

for (const relativePath of ['README.md', 'README.ja.md']) {
  const readme = readFileSync(resolve(repoRoot, relativePath), 'utf8')
  for (const expected of ['docs/public/icon.svg', 'sunwood-ai-labs.github.io/delegate-to-grok-skill']) {
    if (!readme.includes(expected)) throw new Error(`${relativePath} is missing ${expected}`)
  }
}

console.log('Documentation structure verification passed.')
