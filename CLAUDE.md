# Project Guide — odsi-app-catalog

Searchable static catalog of **NASA ODSI** apps, skills & references. It **references**
(links out to) each tool's real GitHub repo — it never hosts or copies the tool.

- Live: https://odsi-app-catalog.netlify.app
- Repo: `NASA-IMPACT/odsi-app-catalog` (public). Brand is "NASA ODSI"; the GitHub **org**
  is `NASA-IMPACT` (no `NASA-ODSI` org exists — don't try to push to one).

## Stack

Astro 5 (static, no adapter) + `@astrojs/mdx` + Pagefind 1.x. Node 20 (`.nvmrc`). No React.

## Run / build

```bash
npm install
npm run dev       # http://localhost:4321
npm run build     # astro build → then postbuild: `pagefind --site dist`
npm run preview   # serve dist/ (needed to exercise real search)
npm run new-entry # interactive scaffold for a new catalog entry
```

## Architecture / key files

- One entry = one MDX file in `src/content/catalog/`. Filename = slug = route.
- `src/content.config.ts` — the collection schema (Zod). **Single source of truth for fields.**
- `src/pages/index.astro` → `src/components/CatalogGrid.astro` — the card grid + search/filter UI.
- `src/pages/catalog/[id].astro` → `src/layouts/EntryLayout.astro` — the detail page (renders
  Limitations, Developer's suggestion, video, then the MDX body via `render(entry)`).
- `src/components/VideoEmbed.astro` — local `<video>` vs youtube/vimeo click-to-load facade;
  shows "coming soon" when `video.src` is a `REPLACE_WITH_*` placeholder.
- `scripts/gen-demo-videos.sh` — regenerates the demo clips in `public/videos/`.

## Non-obvious constraints & gotchas

- **`limitations` is REQUIRED (min 1)** — enforced by the Zod schema, so an entry with an
  empty/missing `limitations` list **fails `astro build` and CI**. This is a product
  requirement ("every entry must acknowledge ≥1 risk"), not a style rule. Don't relax it.
- **Pagefind search only works after a build.** `/pagefind/` doesn't exist in `astro dev`.
  In dev, type/tag filters still work (pure DOM) and free-text falls back to a substring
  match; real full-text needs `npm run build && npm run preview`.
- **Pagefind is imported dynamically via a runtime-built string + `/* @vite-ignore */`** in
  `CatalogGrid.astro` so Vite doesn't try to resolve `/pagefind/pagefind.js` at build time.
  Keep that pattern.
- **Only detail pages are indexed.** They carry `data-pagefind-body` + `data-pagefind-filter`
  (type/tag) + `data-pagefind-meta`. The index page is intentionally NOT indexed (so search
  results map to entries, not the grid page).
- **`ENTRY_TYPES` is duplicated** in `src/content.config.ts` and `scripts/new-entry.mjs` — keep
  them in sync when adding a type.
- **Demo videos are illustrative schematic animations** (ffmpeg, `scripts/gen-demo-videos.sh`),
  not real screen recordings. Commit small clips only (≤ ~5 MB); **no Git LFS**. Prefer
  external youtube/vimeo embeds for larger/real demos.
- `astro.config.mjs` `site` is context-aware from Netlify env (`DEPLOY_PRIME_URL || URL`);
  don't hardcode a URL.

## Deploy (Netlify)

- Site `odsi-app-catalog`, built from `main`, `command = npm run build`, `publish = dist`.
- **main → production auto-deploy works** via a Netlify build hook + a GitHub `push` webhook
  (interim mechanism). The site's git clone uses a read-only **deploy key** on the repo.
- **PR Deploy Previews are NOT yet enabled.** They require the site's git connection to be made
  through the **Netlify GitHub App** (a one-time action in the Netlify UI: Project →
  Build & deploy → link/manage repository). After connecting via the App, remove the interim
  `github-push-main` webhook + deploy key to avoid duplicate builds. See `docs/DECISIONS.md`.

## Conventions

- Commits: human author only — **no Claude/AI co-author trailers**.
- Use markdown links for file references in prose; absolute paths in code.
