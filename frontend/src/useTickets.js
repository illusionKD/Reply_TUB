import { useEffect, useState } from 'react'
import sampleTickets from './data/sampleTickets.json'
import { processTicket as callBackend } from './api'

const STORAGE_KEY = 'openday-tickets-v1'

function seedTickets() {
  const now = new Date().toISOString()
  return sampleTickets.map((t) => ({
    id: t.id,
    message: t.message,
    category: t.category,
    status: 'new', // new | ready_for_review | needs_escalation | resolved | archived
    urgency: null,
    decision: null,
    draft: null,
    source: null,
    createdAt: now,
  }))
}

function loadInitial() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (raw) return JSON.parse(raw)
  } catch {
    // localStorage unavailable or corrupted - fall back to seeding fresh
  }
  return seedTickets()
}

// CRUD over the ticket queue, entirely client-side (per-browser, not shared
// across teammates' machines). AI processing still calls the real backend -
// only the ticket list/status lives here.
export function useTickets() {
  const [tickets, setTickets] = useState(loadInitial)
  const [error, setError] = useState(null)
  const [processingId, setProcessingId] = useState(null)

  useEffect(() => {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(tickets))
    } catch {
      // best-effort persistence only
    }
  }, [tickets])

  function createTicket(message, category) {
    const ticket = {
      id: crypto.randomUUID().slice(0, 8),
      message,
      category: category || 'Unknown',
      status: 'new',
      urgency: null,
      decision: null,
      draft: null,
      source: null,
      createdAt: new Date().toISOString(),
    }
    setTickets((prev) => [ticket, ...prev])
    return ticket.id
  }

  function updateTicket(id, fields) {
    setTickets((prev) => prev.map((t) => (t.id === id ? { ...t, ...fields } : t)))
  }

  function archiveTicket(id) {
    updateTicket(id, { status: 'archived' })
  }

  async function processTicket(id) {
    const ticket = tickets.find((t) => t.id === id)
    if (!ticket) return
    setProcessingId(id)
    setError(null)
    try {
      const result = await callBackend(ticket.message, ticket.category)
      updateTicket(id, {
        draft: result.draft,
        urgency: result.urgency,
        decision: result.decision,
        source: result.source,
        status: result.decision, // ready_for_review | needs_escalation
      })
    } catch (err) {
      setError(err.message)
    } finally {
      setProcessingId(null)
    }
  }

  function resetToSampleData() {
    setTickets(seedTickets())
  }

  return {
    tickets,
    error,
    processingId,
    createTicket,
    updateTicket,
    archiveTicket,
    processTicket,
    resetToSampleData,
  }
}
