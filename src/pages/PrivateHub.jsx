import { useNavigate } from 'react-router-dom'
import { lock } from '../components/RequireGate.jsx'
import sections from '../../data/private.json'

export default function PrivateHub() {
  const navigate = useNavigate()

  function handleLock() {
    lock()
    navigate('/', { replace: true })
  }

  return (
    <section className="max-w-4xl mx-auto px-6 py-24">
      <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-3 text-center">
        Private
      </p>
      <h1 className="font-display text-5xl mb-12 text-center">Inside</h1>

      <div className="grid md:grid-cols-2 gap-8">
        {sections.items.map((s) => (
          <a
            key={s.slug}
            href={s.href}
            className="group block border border-silver/40 p-8 hover:border-ink transition"
            target={s.external ? '_blank' : undefined}
            rel={s.external ? 'noreferrer' : undefined}
          >
            <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-3">
              {s.category}
            </p>
            <h3 className="font-display text-2xl mb-2">{s.title}</h3>
            <p className="text-ink/70">{s.summary}</p>
            <p className="font-ui text-xs uppercase tracking-widest mt-6 group-hover:underline">
              {s.status === 'ready' ? 'Open →' : 'Coming →'}
            </p>
          </a>
        ))}
      </div>

      <p className="text-center mt-16">
        <button
          onClick={handleLock}
          className="font-ui text-xs uppercase tracking-widest text-ink/50 hover:text-ink underline underline-offset-4"
        >
          Sign out
        </button>
      </p>
    </section>
  )
}
