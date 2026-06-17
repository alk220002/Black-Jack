// REQ-001 | Msari Alkaabi
// Steuerungsbuttons – Hit, Stand, Neues Spiel

import './GameControls.css'

/**
 * Zeigt die Spielsteuerung an.
 * @param {{ onHit, onStand, onNewGame, gameOver: boolean }} props
 */
export default function GameControls({ onHit, onStand, onNewGame, gameOver }) {
  return (
    <div className="controls">
      {!gameOver ? (
        <>
          <button className="btn btn--hit" onClick={onHit}>
            Hit
          </button>
          <button className="btn btn--stand" onClick={onStand}>
            Stand
          </button>
        </>
      ) : (
        <button className="btn btn--new" onClick={onNewGame}>
          Neues Spiel
        </button>
      )}
    </div>
  )
}
