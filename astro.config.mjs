// @ts-check
import { defineConfig } from 'astro/config';
import mdx from '@astrojs/mdx';

// Static build. No adapter — deploys as plain files on Netlify.
// Canonical `site` is context-aware: Netlify sets DEPLOY_PRIME_URL (unique per
// deploy, incl. PR Deploy Previews) and URL (production). Falls back to localhost.
const site =
  process.env.DEPLOY_PRIME_URL || process.env.URL || 'http://localhost:4321';

export default defineConfig({
  site,
  integrations: [mdx()],
});
