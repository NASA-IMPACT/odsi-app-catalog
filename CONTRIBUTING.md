# Contributing an entry

Every app, skill, or reference in this catalog is one Markdown/MDX file in
[`src/content/catalog/`](src/content/catalog/). The filename is the URL slug
(`display-blackout.mdx` → `/catalog/display-blackout`).

## Fastest path

```bash
npm run new-entry     # prompts for everything, including >=1 limitation
npm run build         # validates; fails loudly on bad frontmatter
```

Open a PR. CI runs `npm run build`; Netlify posts a Deploy Preview. Merge to `main`
deploys production.

## Frontmatter reference

```yaml
---
title: "Display Blackout"                 # required
description: "One line, <= 280 chars."    # required — shown on the card
type: "Swift/macOS app"                    # required — must be one of the allowed types
tags: ["macos", "swift", "multi-monitor"] # optional but improves search
limitations:                               # REQUIRED — at least one (see below)
  - "macOS only; no Windows/Linux."
repo: "https://github.com/org/name"        # required — the real source repo
homepage: "https://example.com"            # optional
devSuggestion:                             # optional — a "make it yours" tip
  text: "Wrap it in a shell alias and fork it to point at your own links."
  alias: "alias foo='…'"                    # optional shell-alias snippet
video:                                     # optional demo
  provider: youtube                        # youtube | vimeo | local
  src: "YOUTUBE_ID"                         # id, or "/videos/clip.mp4" for local
  poster: "/videos/clip-poster.jpg"         # optional (local only)
author: "Your Name"                         # optional (defaults to NASA ODSI)
dateAdded: 2026-07-24                       # required (YYYY-MM-DD)
featured: false                             # optional
draft: false                                # optional — true hides it from the site
---

## What it does
Markdown/MDX documentation goes here.
```

### Allowed `type` values

`GitHub Action` · `Swift/macOS app` · `Claude skill` · `CLI` · `Web app` · `Python`
· `Library` · `Reference`

Need a new type? Add it to `ENTRY_TYPES` in
[`src/content.config.ts`](src/content.config.ts) (and the mirrored list in
[`scripts/new-entry.mjs`](scripts/new-entry.mjs)) in the same PR.

## Limitations are required

**Every entry must acknowledge at least one limitation or risk.** This is enforced by
the schema (`limitations` must be a non-empty list), so an entry with none will *fail
the build and the CI check* — it is not optional and not just a review convention.

Write honest, useful limitations, e.g.:

- Platform constraints ("macOS + zsh only").
- Permissions/setup friction ("needs Accessibility permission, or fails silently").
- Maturity/security caveats ("no signed binary; build from source", "no tests yet").
- Scope limits ("handles at most 3 displays").

They render in a prominent **⚠ Limitations & Risks** panel on the entry page, and the
count shows on the catalog card.

## Videos

- **Prefer external embeds** (`provider: youtube` or `vimeo`) for real demos — zero repo
  weight. Use the video's id, not the full URL.
- **Small local clips** (`provider: local`) may be committed under
  [`public/videos/`](public/videos/) — keep each **≤ ~5 MB** (ideally ≤ 3 MB, ≤ 20 s,
  720p, H.264 MP4) and include a `poster` still. **Do not** use Git LFS.
- If a clip is bigger than that, put it on YouTube/Vimeo and embed it instead.
