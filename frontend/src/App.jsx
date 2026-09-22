import { useState } from 'react'
import TicketForm from './components/TicketForm'
import ResponseDisplay from './components/ResponseDisplay'
import { submitTicket } from './api'

export default function App() {
  const [ticket, setTicket] = useState('')
  const [category, setCategory] = useState('')
  const [loading, setLoading] = useState(false)
  const [result, setResult] = useState(null)
  const [error, setError] = useState(null)

  async function handleSubmit() {
    setLoading(true)
    setError(null)
    setResult(null)
    try {
      const data = await submitTicket(ticket, category)
      setResult(data)
    } catch (err) {
      setError(err.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <main style={{ maxWidth: '700px', margin: '2rem auto', fontFamily: 'sans-serif' }}>
      <h1>Musterhandel Retail - Ticket Assistant</h1>
      <p>Internal tool for support employees. Drafts are AI-generated and require human review.</p>

      <TicketForm
        ticket={ticket}
        setTicket={setTicket}
        category={category}
        setCategory={setCategory}
        onSubmit={handleSubmit}
        loading={loading}
      />

      <ResponseDisplay result={result} error={error} />
    </main>
  )
}
