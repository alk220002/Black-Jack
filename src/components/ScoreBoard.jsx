// REQ-002 | Petrit Suroji
// ScoreBoard-Komponente – zeigt Spielergebnis an

import './ScoreBoard.css'

const MESSAGES = {
  player: { text: '🎉 Du gewinnst!', cls: 'scoreboard--win' },
  dealer: { text: '😔 Dealer gewinnt!', cls: 'scoreboard--lose' },
  bust: { text: '💥 Bust! Über 21!', cls: 'scoreboard--bust' },
  push: { text: '🤝 Unentschieden!', cls: 'scoreboard--push' },
}

/**
 * Zeigt das Spielergebnis an.
 * @param {{ result: 'player' | 'dealer' | 'bust' | 'push' | null }} props
 */
export default function ScoreBoard({ result }) {
  if (!result) return null

  const { text, cls } = MESSAGES[result] ?? { text: '', cls: '' }

  return (
    <div className={`scoreboard ${cls}`}>
      <span>{text}</span>
    </div>
  )
}
