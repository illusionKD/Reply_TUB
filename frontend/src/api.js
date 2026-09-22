const API_URL = import.meta.env.VITE_API_URL

export async function checkHealth() {
  const res = await fetch(`${API_URL}/health`)
  if (!res.ok) throw new Error(`Health check failed (${res.status})`)
  return res.json()
}

// Add your own functions here as you build the ticket endpoints
// (e.g. processTicket, listTickets) - see docs/functional-requirements.md.
