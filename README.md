# lockandhart.com

The Lockhart story, integrated for the first time. Public site + future shop.

See [CLAUDE.md](./CLAUDE.md) for working agreement and brand rules.
See [PROJECT.md](./PROJECT.md) for vision, architecture, and roadmap.

## Quick start

```powershell
npm install
npm run dev
```

Opens at http://localhost:5173.

## Scripts

| Command | What it does |
|---|---|
| `npm run dev` | Local dev server with HMR |
| `npm run build` | Production build to `dist/` |
| `npm run preview` | Serve the production build locally |
| `npm run lint` | Lint with ESLint |

## Stack

- Vite + React 19
- Tailwind CSS v4
- MDX 3 for narrative content
- React Router 7
- Deployed to Netlify (apex `lockandhart.com` + `www`)
