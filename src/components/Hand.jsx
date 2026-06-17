// REQ-001 | Msari Alkaabi
// Hand-Komponente – zeigt eine Liste von Karten an

import Card from './Card'
import './Hand.css'

/**
 * Zeigt eine Kartenhand an.
 * @param {{ cards: Array, hideSecond: boolean, label: string }} props
 */
export default function Hand({ cards, hideSecond = false, label }) {
  return (
    <div className="hand">
      {label && <p className="hand__label">{label}</p>}
      <div className="hand__cards">
        {cards.map((card, index) => (
          <Card
            key={index}
            card={card}
            hidden={hideSecond && index === 1}
          />
        ))}
      </div>
    </div>
  )
}
