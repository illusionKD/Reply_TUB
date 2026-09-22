const API_URL = import.meta.env.VITE_API_URL

export async function submitTicket(ticket, category) {
  const res = await fetch(`${API_URL}/tickets/respond`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ ticket, category: category || null }),
  })

  const data = await res.json().catch(() => null)

  if (!res.ok) {
    const message = data?.detail || `Request failed (${res.status})`
    throw new Error(typeof message === 'string' ? message : JSON.stringify(message))
  }

  return data
}

export async function checkHealth() {
  const res = await fetch(`${API_URL}/health`)
  if (!res.ok) throw new Error(`Health check failed (${res.status})`)
  return res.json()
}
