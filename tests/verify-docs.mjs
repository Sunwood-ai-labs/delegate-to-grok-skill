import { existsSync, readFileSync } from 'node:fs'
import { resolve } from 'node:path'

const repoRoot = resolve(import.meta.dirname, '..')
const docsRoot = resolve(repoRoot, 'docs')
const requiredFiles = [
  '.vitepress/config.mts',
  '.vitepress/theme/index.ts',
  '.vitepress/theme/style.css',
  'public/icon.svg',
  'public/header-v2.png',
  'public/header-v3.png',
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
if (!icon.includes('<svg') || !icon.includes('Delegate to Grok orchestration lanes')) {
  throw new Error('The shared icon SVG is incomplete.')
}

const brandSurfaces = [
  'README.md',
  'README.ja.md',
  'docs/index.md',
  'docs/ja/index.md',
  'docs/.vitepress/config.mts'
]

for (const relativePath of ['README.md', 'README.ja.md']) {
  const readme = readFileSync(resolve(repoRoot, relativePath), 'utf8')
  for (const expected of ['docs/public/icon.svg', 'docs/public/header-v3.png', 'sunwood-ai-labs.github.io/delegate-to-grok-skill']) {
    if (!readme.includes(expected)) throw new Error(`${relativePath} is missing ${expected}`)
  }

  if (!readme.trimStart().startsWith('<p align="center">\n  <img src="docs/public/header-v3.png"')) {
    throw new Error(`${relativePath} must begin with the standalone v3 header image.`)
  }

  const headerEnd = readme.indexOf('</p>')
  if (readme.slice(0, headerEnd).includes('docs/public/icon.svg')) {
    throw new Error(`${relativePath} must not place the icon before the header.`)
  }

  if (readme.lastIndexOf('docs/public/icon.svg') < readme.lastIndexOf('## 📄')) {
    throw new Error(`${relativePath} must place the icon in its footer.`)
  }
}

for (const relativePath of brandSurfaces) {
  const content = readFileSync(resolve(repoRoot, relativePath), 'utf8')
  for (const forbidden of ['Defensive', 'What it protects', '保護すること', 'Safety first', '安全を最優先', 'protective shield', 'shield and route', 'シールド', 'header-v1.png']) {
    if (content.includes(forbidden)) throw new Error(`${relativePath} retains defense-first brand text: ${forbidden}`)
  }
}

for (const [relativePath, required] of [
  ['docs/index.md', 'Codex-to-Grok delegation for real work'],
  ['docs/ja/index.md', 'Codex から Grok Build へ仕事を委譲']
]) {
  if (!readFileSync(resolve(repoRoot, relativePath), 'utf8').includes(required)) {
    throw new Error(`${relativePath} is missing its delegation-first identity statement.`)
  }
}

console.log('Documentation structure verification passed.')
