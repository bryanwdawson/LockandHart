import { Navigate, useLocation } from 'react-router-dom'

const KEY = 'lh_gate_v1'

export function isUnlocked() {
  if (typeof window === 'undefined') return false
  return window.localStorage.getItem(KEY) === 'unlocked'
}

export function unlock() {
  window.localStorage.setItem(KEY, 'unlocked')
}

export function lock() {
  window.localStorage.removeItem(KEY)
}

export default function RequireGate({ children }) {
  const location = useLocation()
  if (!isUnlocked()) {
    return <Navigate to="/private" state={{ from: location.pathname }} replace />
  }
  return children
}
