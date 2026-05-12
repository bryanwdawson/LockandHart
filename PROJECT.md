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
Self-contained Japan recap pins. The recap is fully isolated at `public/private/japan/`; it does NOT share schema with the React app's `data/`. The renderer is `public/private/japan/index.html` (vanilla JS, no build step).

**Core fields** (required for a usable pin):
- `id` — kebab-case unique. Used in URL hash (`#pin=foo`) so changing it breaks bookmarks.
- `type` — `shrine` / `food` / `neighborhood` / `hike` / `landmark` / `shop` / `transit`. Drives marker color.
- `title` — display name.
- `coords` — `[lat, lon]`.
- `visited` — ISO date `"2026-04-19"`, comma-separated for multiple `"2026-04-19, 2026-04-27"`, or `"?"` for unknown (then `status: "candidate"`).
- `status` — `"confirmed"` or `"candidate"` (candidates render with dashed-border marker).
- `photos` — array of filenames (relative to `photos/`). Order matters: first photo is fallback hero.
- `hero` — single filename, used as the panel header image. Falls back to `photos[0]` if absent.
- `tags` — array of short tags for grouping.
- `facts` — dict with optional keys `kid` / `tip` / `wow` / `local` / `history` / `deity` / `ritual` / `symbol` / `food`. Each is a single string. Rendered as `<h3>` + `<p>` sections in a specific order. `tip` renders with accent-colored highlight.
- `wiki` — single URL (typically Wikipedia). Rendered as a "Read on Wikipedia ↗" link.

**Optional rich-content fields** (added 2026-05):
- `menu` — array of `{ name, note?, fact? }`. Renders as a labeled "Menu" list. Use when you have the actual menu or can confirm what was eaten.
- `extra_cards` — array of `{ title, body, source? }`. Renders as bordered context cards below `facts`. Use for historical / cultural / personal blurbs that don't fit the existing fact keys. The `source` is rendered as a "Source ↗" link.
- `videos` *(planned)* — array of `{ id, title }` for YouTube unlisted embeds. Renderer not built yet; will use `youtube-nocookie.com/embed/<id>` iframe below the photo grid. Wired when the first batch of links lands.

### `public/private/japan/days.json`
Day-by-day narrative. Self-contained alongside pins.json.

- `_doc` — schema docstring.
- `trip` — *(optional)* trip-level meta narrative: `title`, `tagline`, `intro`, `team`, `stakes`, `discipline`, `routine`, `wandering`, `standing_out`, `this_is_the_way`, `food`, `team_rhythm`. Currently stashed as data — no UI surface yet. Future addition: an "About this trip" panel/page that renders these.
- `days` — array of day objects, each: `day` (int 0–10), `date` (ISO), `title`, `opening_quote` (nullable string), `summary` (string), `moments` (array of strings), `themes` (array — `work`/`food`/`cultural`/`spiritual`/`comedy`).
- `people` — array of `{ name, role, days[], notes }`. Names are pseudonyms (Doug, Clair, Saul, Alex, Vicky). Surfaces in the day-overview card as "person chips."

### Renderer features

- **Tile control** (top-right of map): JP (CartoDB Voyager labels-under) / EN (CartoDB Positron) / Off. Preference saved to `localStorage`.
- **Lightbox**: photo viewer with prev/next chevrons, counter, swipe gesture (touch), and a first-visit hint. Tap outside or `✕` to close.
- **Detail panel**: opens on pin click. Top bar has "← Back to map" text button + `✕`. Renders hero → photo grid → narrative (`facts`, `menu`, `extra_cards`) → tags.
- **Day overview card**: opens on day-pill click. Shows day metadata + a "View day in photos" CTA that opens the **day photo-journey modal** — all photos from that day's pins, in chronological order, click to lightbox.
- **Privacy**: page is behind the React-app `/private` password gate at the route level, but the static HTML at `public/private/japan/index.html` is served directly by Netlify. `<meta name="robots" content="noindex, nofollow">` keeps crawlers out. The gate is velvet rope, not a vault.

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
