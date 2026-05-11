import { Link } from 'react-router-dom'

export default function NotFound() {
  return (
    <section className="max-w-xl mx-auto px-6 py-32 text-center">
      <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-6">
        Off the path
      </p>
      <h1 className="font-display text-5xl mb-6">Not found.</h1>
      <p className="text-ink/70 mb-10">
        The page you tried to reach isn't here yet.
      </p>
      <Link
        to="/"
        className="inline-block font-ui text-xs uppercase tracking-widest border border-ink px-6 py-3 hover:bg-ink hover:text-ivory transition"
      >
        Return home →
      </Link>
    </section>
  )
}
