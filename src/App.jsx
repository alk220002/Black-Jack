// REQ-001 | Msari Alkaabi
// Haupt-App-Komponente: Spielzustand & Logik-Orchestrierung

import { useState } from 'react'
import Hand from './components/Hand'
import GameControls from './components/GameControls'
import { startGame, dealerPlay } from './utils/gameState'
import { dealCard } from './utils/deck'
// REQ-002-Abhängigkeit: ScoreBoard und gameLogic werden von Petrit implementiert
import ScoreBoard from './components/ScoreBoard'
import { calculateScore, determineWinner } from './utils/gameLogic'
import './App.css'

export default function App() {
  const [gameState, setGameState] = useState(null)
  const [gameOver, setGameOver] = useState(false)
  const [result, setResult] = useState(null)
  const [dealerRevealed, setDealerRevealed] = useState(false)

  function handleNewGame() {
    const { playerHand, dealerHand, deck } = startGame()
    setGameState({ playerHand, dealerHand, deck })
    setGameOver(false)
    setResult(null)
    setDealerRevealed(false)
  }

  // REQ-001: Spieler zieht eine Karte
  function handleHit() {
    if (!gameState || gameOver) return
    const { card, remainingDeck } = dealCard(gameState.deck)
    const newHand = [...gameState.playerHand, card]
    const score = calculateScore(newHand)

    if (score > 21) {
      setGameState({ ...gameState, playerHand: newHand, deck: remainingDeck })
      setDealerRevealed(true)
      setResult('bust')
      setGameOver(true)
    } else {
      setGameState({ ...gameState, playerHand: newHand, deck: remainingDeck })
    }
  }

  // REQ-001: Spieler steht – Dealer zieht
  function handleStand() {
    if (!gameState || gameOver) return
    const { hand: finalDealerHand } = dealerPlay(
      gameState.dealerHand,
      gameState.deck,
      calculateScore,
    )
    const winner = determineWinner(gameState.playerHand, finalDealerHand)
    setGameState({ ...gameState, dealerHand: finalDealerHand })
    setDealerRevealed(true)
    setResult(winner)
    setGameOver(true)
  }

  const playerScore = gameState ? calculateScore(gameState.playerHand) : 0
  const dealerScore =
    gameState && dealerRevealed ? calculateScore(gameState.dealerHand) : null

  return (
    <div className="app">
      <h1 className="app__title">♠ BlackJack ♠</h1>
      <p className="app__subtitle">Msari Alkaabi &amp; Petrit Suroji</p>

      {!gameState ? (
        <button className="btn btn--new" onClick={handleNewGame}>
          Spiel starten
        </button>
      ) : (
        <>
          <Hand
            cards={gameState.dealerHand}
            hideSecond={!dealerRevealed}
            label={`Dealer${dealerScore !== null ? ` (${dealerScore})` : ''}`}
          />

          <Hand
            cards={gameState.playerHand}
            label={`Spieler (${playerScore})`}
          />

          <ScoreBoard result={result} />

          <GameControls
            onHit={handleHit}
            onStand={handleStand}
            onNewGame={handleNewGame}
            gameOver={gameOver}
          />
        </>
      )}
    </div>
  )
}
