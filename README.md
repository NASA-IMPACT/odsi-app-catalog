# odsi-app-catalog

**Live:** https://odsi-app-catalog.netlify.app · deploys from `main`, with a Deploy Preview per PR.

A single, searchable front door to apps, skills, and reference tools built across
**NASA ODSI**. The catalog does **not** host or copy the tools — every entry links
out to the real GitHub repo. Search by name, filter by type or tag, watch a demo,
read what a tool does, and see its documented limitations.

Built with [Astro](https://astro.build) (typed content collections) +
[Pagefind](https://pagefind.app) (static full-text search), deployed on Netlify.

## Quick start

```bash
nvm use            # Node 20 (see .nvmrc)
npm install
npm run dev        # http://localhost:4321  (search index is build-only — see note)
```

> **Search in dev:** Pagefind indexes the *built* site, so full-text search only
> works after `npm run build`. In `npm run dev`, type/tag filters work and free-text
> falls back to a title/description/tag match. To exercise real search locally:
>
> ```bash
> npm run build && npm run preview
> ```

## How it works

- Each catalog entry is one Markdown/MDX file in [`src/content/catalog/`](src/content/catalog/).
- Frontmatter is validated at build against a Zod schema in
  [`src/content.config.ts`](src/content.config.ts). Bad data (unknown `type`, malformed
  `repo`, or **no `limitations`**) fails the build — and the CI check.
- `npm run build` runs `astro build`, then the `postbuild` hook `pagefind --site dist`
  writes the search index into `dist/pagefind/`.
- Netlify builds from `netlify.toml` and serves `dist/`.

## Adding an entry

See [CONTRIBUTING.md](CONTRIBUTING.md). The short version:

```bash
npm run new-entry     # interactive scaffold (asks for title, type, tags, repo, limitations…)
npm run build         # validate
```

Then open a PR. Netlify posts a Deploy Preview; merge to `main` deploys production.

## Project layout

```
src/
  content.config.ts      # collection + Zod schema
  content/catalog/*.mdx  # one file per entry
  components/            # EntryCard, CatalogGrid (search/filter), VideoEmbed, badges
  layouts/               # BaseLayout, EntryLayout (renders the Limitations section)
  pages/                 # index.astro (grid) + catalog/[id].astro (detail)
public/videos/           # small committed demo clips (<=5 MB) + posters
scripts/new-entry.mjs    # `npm run new-entry` scaffold
netlify.toml             # build command + publish dir
```

<!-- preview check 2 -->
