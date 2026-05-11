import { Routes, Route } from 'react-router-dom'
import Layout from './components/Layout.jsx'
import Home from './pages/Home.jsx'
import Private from './pages/Private.jsx'
import PrivateHub from './pages/PrivateHub.jsx'
import RequireGate from './components/RequireGate.jsx'
import NotFound from './pages/NotFound.jsx'

export default function Router() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route path="/" element={<Home />} />
        <Route path="/private" element={<Private />} />
        <Route
          path="/private/hub"
          element={
            <RequireGate>
              <PrivateHub />
            </RequireGate>
          }
        />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  )
}
