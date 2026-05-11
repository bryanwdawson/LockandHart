import { Link } from 'react-router-dom'

export default function Nav() {
  return (
    <header className="border-b border-silver/30 bg-ivory">
      <nav className="max-w-6xl mx-auto px-6 py-5 flex items-center justify-center">
        <Link
          to="/"
          className="flex items-center gap-3 hover:opacity-70 transition"
          aria-label="Lock & Hart — home"
        >
          <img
            src="/logos/lock_hart_logo_FINAL.svg"
            alt=""
            className="w-7 h-7"
          />
          <span className="font-display text-2xl tracking-wide">
            Lock &amp; Hart
          </span>
        </Link>
      </nav>
    </header>
  )
}
