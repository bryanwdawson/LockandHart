import { Link } from 'react-router-dom'

export default function Nav() {
  return (
    <header className="border-b border-silver/30 bg-ivory">
      <nav className="max-w-6xl mx-auto px-6 py-5 flex items-center justify-center">
        <Link
          to="/"
          className="font-display text-2xl tracking-wide hover:opacity-70 transition"
        >
          Lock &amp; Hart
        </Link>
      </nav>
    </header>
  )
}
