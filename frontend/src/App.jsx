import { useState } from 'react'
import TicketQueue from './components/TicketQueue'
import TicketDetail from './components/TicketDetail'
import NewTicketForm from './components/NewTicketForm'
import { useTickets } from './useTickets'

export default function App() {
  const { tickets, error, processingId, createTicket, updateTicket, archiveTicket, processTicket, resetToSampleData } =
    useTickets()
  const [selectedId, setSelectedId] = useState(null)

  const selected = tickets.find((t) => t.id === selectedId) || null

  return (
    <main style={{ maxWidth: '1000px', margin: '2rem auto', fontFamily: 'sans-serif', padding: '0 1rem' }}>
      <h1>Musterhandel Retail - Ticket Assistant</h1>
      <p>Internal tool for support employees. The AI drafts and triages; a human always reviews before sending.</p>

      <div style={{ display: 'flex', gap: '2rem' }}>
        <div style={{ flex: '0 0 340px' }}>
          <NewTicketForm onCreate={(message, category) => createTicket(message, category)} />
          <button onClick={resetToSampleData} style={{ marginBottom: '0.75rem', marginLeft: '0.5rem' }}>
            Reset to sample tickets
          </button>
          <TicketQueue tickets={tickets} selectedId={selectedId} onSelect={setSelectedId} />
        </div>

        <div style={{ flex: '1' }}>
          <TicketDetail
            ticket={selected}
            processing={processingId}
            error={selected && error}
            onProcess={processTicket}
            onUpdateDraft={(id, draft) => updateTicket(id, { draft })}
            onSetStatus={(id, status) => updateTicket(id, { status })}
            onArchive={archiveTicket}
          />
        </div>
      </div>
    </main>
  )
}
