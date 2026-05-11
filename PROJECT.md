# PROJECT.md — lockandhart.com

Vision, schema, and roadmap for the website rebuild. Companion to [CLAUDE.md](./CLAUDE.md) (which covers brand + working agreement).

---

## Vision

Move Lock & Hart off Shopify. Build a storytelling-first site that:

1. Tells the Lockhart family story (DOC / TRAD / LEG framing)
2. Hosts shareable trip recaps (Japan first, others later)
3. Eventually sells the V1 product line (pendant, Lee Penny, hoya)
4. Leaves architectural room for play. / hunt. / family. / trip. subdomains

Not in scope for v1: storefront checkout flow, interactive family tree, blog/journal, gated subdomains.

---

## Schema — canonical data shapes

All in `data/`. Site code reads from these; MDX provides the prose.

### `data/site.json`
Site-wide constants: name, taglines, core statement, nav.

### `data/story.json`
Ordered list of story sections. Each entry: `slug`, `title`, `layers[]` (DOC/TRAD/LEG), `summary`. Prose for each lives in `src/content/<slug>.mdx`.

### `data/products.json`
Product catalog. Each item: `slug`, `name`, `category`, `summary`, `status`, `tagline`. Status one of: `In development` / `Coming` / `Available`. Moves to Supabase when storefront activates.

### `public/private/japan/pins.json`
Self-contained Japan recap pins. Beyond the core fields (`id`, `type`, `title`, `coords`, `visited`, `photos`, `hero`, `facts`, `tags`, `wiki`), each pin can optionally carry:
- `menu` — array of `{ name, note?, fact? }`. Renders as a "Menu" list in the detail panel. Use when you have the actual menu / can confirm what was eaten.
- `extra_cards` — array of `{ title, body, source? }`. Renders as bordered context cards below facts. Use for historical / contextual blurbs that don't fit the existing fact keys.

The recap is self-contained at `public/private/japan/`; it does not share schema with the React app's `data/`.

---

## Routes (v1)

### Public
| Route | Component | Source | Status |
|---|---|---|---|
| `/` | `Home.jsx` | `content/home.mdx` + site/story JSON | Scaffolded |
| `*` | `NotFound.jsx` | — | Scaffolded |

### Private (behind password gate)
| Route | Component | Source | Status |
|---|---|---|---|
| `/private` | `Private.jsx` | hardcoded password | Scaffolded |
| `/private/hub` | `PrivateHub.jsx` (gated) | `data/private.json` | Scaffolded |
| `/private/japan/` | static folder | drop-in from Japan Trip Cowork project | Live |

### Deferred (architected to slot in)
- `/products/[slug]` and `/shop` — when storefront activates
- `/private/games/*` — for future game deploys (e.g., Family Feud)
- `/the-name`, `/simon`, `/lee-penny` — if story grows beyond a single-page narrative
- `/about`, `/journal`, `/contact`

---

## Roadmap

### v1 — Storytelling site (current)
- [x] Repo scaffolded, dev server clean
- [x] Brand tokens locked in Tailwind theme
- [x] Home page narrative pass (DOC/TRAD layers + coda)
- [x] Logo SVGs in place
- [x] Japan static folder dropped in (528 photos, all upright)
- [x] Code-level Lighthouse pre-flight (canonical, OG/Twitter image, theme-color, contrast fix)
- [ ] DNS cutover Shopify → Netlify
- [ ] Cancel Shopify subscription
- [ ] Lighthouse pass on real Netlify build

### v2 — Storefront
- Stripe Checkout via Netlify Function
- Supabase products table (inventory + stock)
- Product detail pages
- Email receipts via Stripe + transactional sender

### v3 — Subdomain expansion (each its own repo/site)
- play. — Family Feud + future games (was the canary for the stack)
- trip. — extract `/japan` here, add future trips
- hunt. — Easter / seasonal hunt engine
- family. — shared calendar + RSVP

---

## Dependencies (pinned by `package.json`, locked by `package-lock.json`)

Runtime:
- `react`, `react-dom`
- `react-router-dom`
- `@mdx-js/react`, `@mdx-js/rollup`
- `tailwindcss`, `@tailwindcss/vite`

Build/dev:
- `vite`, `@vitejs/plugin-react`
- `eslint` + standard plugins (from Vite scaffold)

No other top-level deps without flagging the addition in the session.

---

## Operational notes

- **Dev:** `npm run dev` on port 5173
- **Build:** `npm run build` → `dist/`
- **Preview build:** `npm run preview`
- **Deploy:** push to `main` → Netlify auto-builds. Branch pushes get preview URLs.
- **Env vars:** `.env.example` is the contract. Real values go in Netlify dashboard.

---

## Decision log

| Date | Decision | Why |
|---|---|---|
| 2026-05-11 | Single repo, apex only | Subdomains all deferred; splitting now is premature |
| 2026-05-11 | JavaScript, not TypeScript | Content site at this scale; TS adds friction |
| 2026-05-11 | MDX for content, not Notion-as-CMS | Git-versioned brand-sensitive copy; no API sync layer |
| 2026-05-11 | Stripe direct, not Shopify Lite | Full ownership; no $9/mo to stay tethered to platform we're leaving |
| 2026-05-11 | Tailwind v4 | Current major; theme tokens in CSS, no separate config file |
| 2026-05-11 | Fonts: Cormorant Garamond + Source Serif 4 + Inter | Heirloom feel; free via Google Fonts |
| 2026-05-11 | Public surface = only `/`. No public nav links. | Bryan: site is Lockhart story; Japan/games are not for public |
| 2026-05-11 | `/private` password gate (client-side, "2026" hardcoded) | Velvet rope acceptable for v1; family/friend access not requiring real auth |
| 2026-05-11 | Japan static drops at `public/private/japan/`, not `public/japan/` | Path under `/private/` keeps URL out of public discovery and aligns with gate model |
| 2026-05-11 | DOC / TRAD / LEG layers stay as a writing discipline, not a UI chip | Chips added visual noise without serving the story. Layers still govern voice in copy |
| 2026-05-11 | Japan map default tile = CartoDB Voyager (Japanese labels, clean water) | Raw OSM rendered dashed maritime borders that looked noisy |
| 2026-05-11 | Drop the companion filter on the Japan map | Filtering by who Bryan was with isn't a search pattern anyone uses; UI clutter |
