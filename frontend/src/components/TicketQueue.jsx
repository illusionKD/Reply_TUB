import { STATUS_LABEL, STATUS_COLOR, URGENCY_COLOR } from '../statusStyles'

export default function TicketQueue({ tickets, selectedId, onSelect }) {
  const visible = tickets.filter((t) => t.status !== 'archived')

  if (visible.length === 0) {
    return <p style={{ color: '#666' }}>No tickets in the queue.</p>
  }

  return (
    <ul style={{ listStyle: 'none', padding: 0, margin: 0 }}>
      {visible.map((t) => (
        <li key={t.id}>
          <button
            onClick={() => onSelect(t.id)}
            style={{
              display: 'block',
              width: '100%',
              textAlign: 'left',
              padding: '0.6rem 0.75rem',
              marginBottom: '0.4rem',
              border: '1px solid #ddd',
              borderLeft: t.id === selectedId ? '4px solid #2b5fd9' : '4px solid transparent',
              background: t.id === selectedId ? '#eef2ff' : '#fff',
              cursor: 'pointer',
              borderRadius: '4px',
            }}
          >
            <div style={{ fontWeight: 'bold', fontSize: '0.85rem' }}>{t.category}</div>
            <div
              style={{
                fontSize: '0.75rem',
                color: '#333',
                whiteSpace: 'nowrap',
                overflow: 'hidden',
                textOverflow: 'ellipsis',
              }}
            >
              {t.message}
            </div>
            <div style={{ marginTop: '0.3rem', display: 'flex', gap: '0.4rem' }}>
              <span
                style={{
                  fontSize: '0.7rem',
                  color: '#fff',
                  background: STATUS_COLOR[t.status] || '#666',
                  padding: '0.1rem 0.4rem',
                  borderRadius: '3px',
                }}
              >
                {STATUS_LABEL[t.status] || t.status}
              </span>
              {t.urgency && (
                <span
                  style={{
                    fontSize: '0.7rem',
                    color: '#fff',
                    background: URGENCY_COLOR[t.urgency] || '#666',
                    padding: '0.1rem 0.4rem',
                    borderRadius: '3px',
                  }}
                >
                  {t.urgency} urgency
                </span>
              )}
            </div>
          </button>
        </li>
      ))}
    </ul>
  )
}
