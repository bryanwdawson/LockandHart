# CLAUDE.md — lockandhart.com

Source of truth for Claude sessions on this repo. Pulls from the Notion canon (Brand Brief, Platform Vision, Working Agreement). When canon and this file disagree, **read Notion and update this file** — don't drift.

---

## Notion canon (read first when context is thin)

- [Lock & Hart — Brand Context Brief v1.0](https://www.notion.so/3297fdb3625d8180a02bfcf6adc0d993) — brand truth
- [lockandhart.com — Platform Vision & Future Projects](https://www.notion.so/3317fdb3625d81d9879bc8203b9b49c2) — architecture truth
- [Claude Working Agreement](https://www.notion.so/35c7fdb3625d81f9b018ce48a747b5c0) — how we work
- [Lock & Hart — Business Hub](https://www.notion.so/32a7fdb3625d8191a6a8e743c6c0eb78) — vendors, IDs, expenses

---

## Brand — hard rules

### Name
- **Lock & Hart**. Never "Lock & Heart". Never "House Heart". Both are archived.

### Taglines
- **Legacy, Carried.** — master line, sitewide
- **Sacred. Worn. Kept.** — jewelry only

### Voice
- Short declarative sentences. No exclamation points. No romantic clichés. No fantasy language.
- Lean into: devotion, guardianship, trust, inheritance, things that survive.

### Visual
- Heart is primary. Lock implied via shoulder arc — **never a padlock, never a keyhole**.
- Monoline mark, engravable at 12mm.
- Palette: black (`--color-ink`), ivory (`--color-ivory`), brushed silver, oxblood/garnet as accent only.
- Heading font: Cormorant Garamond. Body: Source Serif 4. UI: Inter.

### Banned
- "Lock & Heart" spelling, anywhere
- Padlock imagery, keyhole imagery
- Tartan merchandise tropes, medieval cosplay, gothic ornament
- Fantasy language ("magical", "mystical", "enchanted")
- Exclamation points
- **The "Stephen Locard saved a king from a boar" story.** No anchor in the family record. Do not use, even as legend.

---

## Story layers — DOC / TRAD / LEG

Every claim about Lockhart history belongs to one of three layers. The tag controls the voice:

| Tag | Voice | Example |
|---|---|---|
| `DOC` | Tell directly | *"Simon Locard was Lord of Lee, recorded in the 1323 charter."* |
| `TRAD` | Family story | *"The story passed down is..." / "Family tradition holds..."* |
| `LEG` | Legend | *"The legend says..."* |

In MDX, render the chip with `<StoryTag t="DOC" />`. The chip is a label, not a license to mix layers — the prose itself must use the right register.

---

## Confirmed website copy (verbatim — do not paraphrase)

- Hero: *"Lock & Hart — The Lockhart story — integrated for the first time."*
- Land: *"Before Seals. Before Legend."* / *"Upper Clydesdale. Annandale. Service and settlement. The Lockhart name emerges from land, record, and responsibility."*
- Simon section title: *"The First Bearing of the Key"*
- Simon section subhead: *"Inheritance becomes responsibility."*

---

## Stack

| Layer | Choice |
|---|---|
| Build | Vite 8 |
| Framework | React 19 (JavaScript, not TypeScript) |
| Routing | React Router 7 |
| Styling | Tailwind v4 (theme tokens in `src/styles/globals.css`) |
| Content | MDX 3 via `@mdx-js/rollup` |
| Host | Netlify (free tier) |
| Domain | lockandhart.com (registrar: Shopify, plan: transfer to Cloudflare post-launch) |
| Repo | https://github.com/bryanwdawson/LockandHart (private) |
| Checkout | Stripe Checkout via Netlify Function (deferred until products ship) |
| DB | None for v1. Add Supabase when storefront or gated subdomains activate. |

---

## Architecture

- **Single Netlify site, single repo, apex only.** play. / hunt. / family. / trip. are deferred. When activated, each becomes its own repo + Netlify site, not a folder here.
- **Public surface is intentionally small.** Only `/` is public. No public nav links — the logo is the only public navigation. No /japan, no /shop on public.
- **Private content sits behind `/private`** (password gate, see below). Personal recaps and games land at `/private/*`.
- `data/*.json` are canonical. MDX + JSX derive from them.

## Gate / Private section

The site has a small private area for family-and-friends content (trip recaps, future games). Public visitors never see it in nav.

- **Entry:** `/private` — a password form. Linked discreetly from the footer ("Private" in small grey type).
- **Password:** hardcoded in `src/pages/Private.jsx`. Current value: `2026`. To rotate: edit that one line and push.
- **Persistence:** localStorage key `lh_gate_v1`. Persists until the user clicks "Sign out" on the hub.
- **Hub:** `/private/hub` — gated by `<RequireGate>`. Lists personal sections from `data/private.json`.
- **Static drop-ins** (e.g., Japan recap) go under `public/private/<name>/`. They are accessed by URL only after the visitor unlocks the gate via the React hub link.

**Velvet rope, not a vault.** The password lives in client-side JS — anyone with browser dev tools can read it. Static URLs under `/private/<name>/` are not server-side protected; they're shielded by URL obscurity only. Search engines: a `robots.txt` Disallow on `/private` prevents indexing.

When real protection is needed: upgrade to a Netlify Edge Function that intercepts `/private/*` requests and checks a signed cookie. The cookie gets set by a small `/api/unlock` Function that verifies the password server-side against an env var. ~50 lines total.

### Repo layout
```
src/
  components/     reusable UI (Layout, Nav, Footer, StoryTag)
  pages/          route components
  content/        MDX prose
  styles/         globals.css (Tailwind + @theme)
  main.jsx        entry
  router.jsx      route table
data/             canonical JSON (story, products, site)
public/           static assets, /japan drop-in
```

---

## Working agreement

- Terse, structured, action-first. State what was found, done, next.
- Move autonomously between user check-ins. Surface findings as intelligence.
- One feature at a time. Working state at every commit.
- No heavy npm deps without surfacing them first.
- Update Notion **directly during the session** when project decisions are made — don't batch.
- "Save and end" / "let's pause" → write memory, update Notion, brief recap, close.

---

## Pre-launch checklist (do NOT ship without)

- [ ] Fix Shopify billing name "Lock & Heart" → "Lock & Hart" (Settings → General → Store details)
- [ ] Cancel Shopify subscription after DNS cutover confirmed
- [ ] Transfer registrar Shopify → Cloudflare (60-day post-purchase lock from Feb 13, 2026 has lifted)
- [ ] Decide Google Workspace: cancel / keep / forward `bryan@lockandhart.com` → Gmail
- [ ] Drop final logo SVGs into `public/logos/`
- [ ] Drop Japan static folder into `public/private/japan/`
- [ ] Add `robots.txt` disallowing `/private` so search engines skip it
- [ ] Confirm DNS records: apex + www → Netlify
- [ ] Run Lighthouse — target 95+ on all four scores
- [ ] Verify all copy passes the banned-words check (no exclamation, no "Heart")

---

## Banned in code

- `console.log` left in production code
- Inline styles when a Tailwind utility exists
- New top-level deps without flagging in the session
- Comments that just narrate what the code does
- Emoji in code or copy (the brand voice is reserved)
