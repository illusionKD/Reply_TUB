import { useEffect, useState } from 'react'
import { checkHealth } from './api'

export default function App() {
  const [status, setStatus] = useState('checking...')

  useEffect(() => {
    checkHealth()
      .then(() => setStatus('live'))
      .catch(() => setStatus('unreachable'))
  }, [])

  return (
    <main style={{ maxWidth: '700px', margin: '2rem auto', fontFamily: 'sans-serif', padding: '0 1rem' }}>
      <h1>Musterhandel Retail - Ticket Assistant</h1>
      <p>
        Backend status: <strong>{status}</strong>
      </p>
      <p style={{ color: '#666' }}>
        This is your starting point - the deployment pipeline works, and that's it. Build the actual ticket
        queue, AI integration, and UI here. See <code>docs/</code> in the repo for the spec.
      </p>
    </main>
  )
}
