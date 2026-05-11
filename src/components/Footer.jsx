import { Link } from 'react-router-dom'

export default function Footer() {
  const year = new Date().getFullYear()
  return (
    <footer className="border-t border-silver/30 mt-24">
      <div className="max-w-6xl mx-auto px-6 py-10 grid grid-cols-1 md:grid-cols-3 items-center gap-4 text-center md:text-left">
        <p className="font-display text-lg">Lock &amp; Hart</p>
        <Link
          to="/private"
          className="font-ui text-[10px] uppercase tracking-widest text-ink/55 hover:text-ink transition md:justify-self-center"
          aria-label="Private section"
        >
          Private
        </Link>
        <p className="font-ui text-xs uppercase tracking-widest text-ink/70 md:justify-self-end">
          Legacy, Carried. &middot; &copy; {year}
        </p>
      </div>
    </footer>
  )
}
