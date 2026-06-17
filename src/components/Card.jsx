// REQ-001 | Msari Alkaabi
// Karten-Komponente – zeigt eine einzelne Spielkarte an

import './Card.css'

const RED_SUITS = ['♥', '♦']

/**
 * Zeigt eine einzelne Spielkarte.
 * @param {{ card: {suit: string, rank: string}, hidden: boolean }} props
 */
export default function Card({ card, hidden = false }) {
  if (hidden) {
    return <div className="card card--hidden">🂠</div>
  }

  const isRed = RED_SUITS.includes(card.suit)

  return (
    <div className={`card ${isRed ? 'card--red' : 'card--black'}`}>
      <span className="card__rank">{card.rank}</span>
      <span className="card__suit">{card.suit}</span>
    </div>
  )
}
