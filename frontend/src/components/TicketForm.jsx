const CATEGORIES = [
  'Order status',
  'Returns and exchanges',
  'Damaged products',
  'Billing and refunds',
  'Order changes and complaints',
  'Unknown',
]

export default function TicketForm({ ticket, setTicket, category, setCategory, onSubmit, loading }) {
  return (
    <form
      onSubmit={(e) => {
        e.preventDefault()
        onSubmit()
      }}
    >
      <label htmlFor="ticket">Customer ticket</label>
      <textarea
        id="ticket"
        rows={6}
        value={ticket}
        onChange={(e) => setTicket(e.target.value)}
        placeholder="Paste or type the customer's message here..."
      />

      <label htmlFor="category">Category</label>
      <select id="category" value={category} onChange={(e) => setCategory(e.target.value)}>
        <option value="">Select a category (optional)</option>
        {CATEGORIES.map((c) => (
          <option key={c} value={c}>
            {c}
          </option>
        ))}
      </select>

      <button type="submit" disabled={loading || !ticket.trim()}>
        {loading ? 'Generating...' : 'Generate draft response'}
      </button>
    </form>
  )
}
