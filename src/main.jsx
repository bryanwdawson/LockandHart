import { StrictMode } from 'react'
import { createRoot } from 'react-dom/client'
import { BrowserRouter } from 'react-router-dom'
import { MDXProvider } from '@mdx-js/react'
import './styles/globals.css'
import Router from './router.jsx'

createRoot(document.getElementById('root')).render(
  <StrictMode>
    <BrowserRouter>
      <MDXProvider>
        <Router />
      </MDXProvider>
    </BrowserRouter>
  </StrictMode>,
)
