import { NavLink, Link } from 'react-router-dom'

const links = [
  { to: '/japan', label: 'Japan' },
  { to: '/shop', label: 'Shop' },
]

export default function Nav() {
  return (
    <header className="border-b border-silver/30 bg-ivory">
      <nav className="max-w-6xl mx-auto px-6 py-5 flex items-center justify-between">
        <Link
          to="/"
          className="font-display text-2xl tracking-wide hover:opacity-70 transition"
        >
          Lock & Hart
        </Link>
        <ul className="flex gap-8 font-ui text-sm uppercase tracking-widest">
          {links.map((l) => (
            <li key={l.to}>
              <NavLink
                to={l.to}
                className={({ isActive }) =>
                  isActive ? 'text-ink' : 'text-ink/60 hover:text-ink transition'
                }
              >
                {l.label}
              </NavLink>
            </li>
          ))}
        </ul>
      </nav>
    </header>
  )
}
