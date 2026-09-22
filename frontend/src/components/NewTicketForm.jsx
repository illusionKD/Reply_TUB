import { useState } from 'react'

const CATEGORIES = [
  'Order status',
  'Returns and exchanges',
  'Damaged products',
  'Billing and refunds',
  'Order changes and complaints',
  'Unknown',
]

export default function NewTicketForm({ onCreate }) {
  const [open, setOpen] = useState(false)
  const [message, setMessage] = useState('')
  const [category, setCategory] = useState('')

  if (!open) {
    return (
      <button onClick={() => setOpen(true)} style={{ marginBottom: '0.75rem' }}>
        + New ticket
      </button>
    )
  }

  return (
    <form
      onSubmit={(e) => {
        e.preventDefault()
        if (!message.trim()) return
        onCreate(message.trim(), category)
        setMessage('')
        setCategory('')
        setOpen(false)
      }}
      style={{ border: '1px solid #ddd', padding: '0.75rem', marginBottom: '0.75rem' }}
    >
      <textarea
        rows={3}
        style={{ width: '100%' }}
        placeholder="New customer ticket message..."
        value={message}
        onChange={(e) => setMessage(e.target.value)}
      />
      <select value={category} onChange={(e) => setCategory(e.target.value)} style={{ display: 'block', margin: '0.4rem 0' }}>
        <option value="">Category (optional)</option>
        {CATEGORIES.map((c) => (
          <option key={c} value={c}>
            {c}
          </option>
        ))}
      </select>
      <button type="submit">Add to queue</button>
      <button type="button" onClick={() => setOpen(false)} style={{ marginLeft: '0.5rem' }}>
        Cancel
      </button>
    </form>
  )
}
