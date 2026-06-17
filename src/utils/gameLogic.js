// REQ-002 | Petrit Suroji
// Score-Berechnung und Gewinner-Ermittlung

/**
 * Berechnet den besten BlackJack-Wert einer Hand.
 * Ass zählt als 11, außer wenn der Gesamtwert über 21 liegt (dann als 1).
 * @param {Array<{suit: string, rank: string}>} hand
 * @returns {number}
 */
export function calculateScore(hand) {
  let score = 0
  let aces = 0

  for (const card of hand) {
    if (card.rank === 'A') {
      aces++
      score += 11
    } else if (['J', 'Q', 'K'].includes(card.rank)) {
      score += 10
    } else {
      score += parseInt(card.rank, 10)
    }
  }

  // Ass auf 1 reduzieren, solange Bust
  while (score > 21 && aces > 0) {
    score -= 10
    aces--
  }

  return score
}

/**
 * Ermittelt das Ergebnis nach Dealer-Zug.
 * @param {Array} playerHand
 * @param {Array} dealerHand
 * @returns {'player' | 'dealer' | 'push' | 'bust'}
 */
export function determineWinner(playerHand, dealerHand) {
  const playerScore = calculateScore(playerHand)
  const dealerScore = calculateScore(dealerHand)

  if (playerScore > 21) return 'bust'
  if (dealerScore > 21) return 'player'
  if (playerScore > dealerScore) return 'player'
  if (dealerScore > playerScore) return 'dealer'
  return 'push'
}
