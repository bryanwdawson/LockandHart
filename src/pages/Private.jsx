import { useState } from 'react'
import { Navigate, useLocation, useNavigate } from 'react-router-dom'
import { isUnlocked, unlock } from '../components/RequireGate.jsx'

// Velvet rope, not a vault. See CLAUDE.md for the upgrade path to signed cookies.
// To rotate: change this string, redeploy. Anyone with localStorage already set stays unlocked.
const PASSWORD = '2026'

export default function Private() {
  const location = useLocation()
  const navigate = useNavigate()
  const [value, setValue] = useState('')
  const [error, setError] = useState(false)
  const returnTo = location.state?.from || '/private/hub'

  if (isUnlocked()) {
    return <Navigate to={returnTo} replace />
  }

  function handleSubmit(e) {
    e.preventDefault()
    if (value === PASSWORD) {
      unlock()
      navigate(returnTo, { replace: true })
    } else {
      setError(true)
      setValue('')
    }
  }

  return (
    <section className="max-w-md mx-auto px-6 py-32">
      <p className="font-ui text-xs uppercase tracking-widest text-ink/60 mb-6 text-center">
        Private
      </p>
      <h1 className="font-display text-4xl mb-10 text-center">Enter</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <input
          type="password"
          autoFocus
          value={value}
          onChange={(e) => { setValue(e.target.value); setError(false) }}
          placeholder="Password"
          className="w-full border border-silver/40 bg-transparent px-4 py-3 font-ui text-center focus:outline-none focus:border-ink"
          aria-label="Password"
        />
        {error && (
          <p className="font-ui text-xs uppercase tracking-widest text-oxblood text-center">
            Try again.
          </p>
        )}
        <button
          type="submit"
          className="w-full font-ui text-xs uppercase tracking-widest border border-ink px-6 py-3 hover:bg-ink hover:text-ivory transition"
        >
          Enter →
        </button>
      </form>
    </section>
  )
}
