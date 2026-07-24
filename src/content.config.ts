import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

// Primary "type" facet. Add new types here as the catalog grows — anything not
// in this list will FAIL the build, which keeps the facet clean.
export const ENTRY_TYPES = [
  'GitHub Action',
  'Swift/macOS app',
  'Claude skill',
  'CLI',
  'Web app',
  'Python',
  'Library',
  'Reference',
] as const;

export type EntryType = (typeof ENTRY_TYPES)[number];

const catalog = defineCollection({
  loader: glob({ base: './src/content/catalog', pattern: '**/*.{md,mdx}' }),
  schema: z.object({
    title: z.string(),
    description: z.string().max(280), // card blurb
    type: z.enum(ENTRY_TYPES), // primary facet
    tags: z.array(z.string()).default([]), // user-defined secondary facets

    // REQUIRED: every entry must acknowledge at least one limitation or risk.
    // .min(1) makes an empty/missing list FAIL `astro build` (and CI) — this is
    // how "must acknowledge >=1 limitation/risk" is enforced, not a convention.
    limitations: z.array(z.string().min(1)).min(1),

    repo: z.string().url(), // GitHub repo (required)
    homepage: z.string().url().optional(), // live site / docs, if any

    // Optional demo video: EITHER a committed local clip under /public/videos
    // (keep <= ~5 MB), OR an external YouTube/Vimeo id.
    video: z
      .object({
        provider: z.enum(['local', 'youtube', 'vimeo']),
        src: z.string(), // "/videos/x.mp4" | youtube/vimeo id
        poster: z.string().optional(), // "/videos/x-poster.jpg" for local
      })
      .optional(),

    author: z.string().default('NASA ODSI'),
    dateAdded: z.coerce.date(),
    featured: z.boolean().default(false),
    draft: z.boolean().default(false), // excluded from the built listing
  }),
});

export const collections = { catalog };
