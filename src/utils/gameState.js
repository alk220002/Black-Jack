// REQ-001 | Msari Alkaabi
// Spielzustands-Verwaltung und Karten-Deal-Logik

import { newShuffledDeck, dealCard } from './deck'

/**
 * Startet ein neues Spiel: Deck mischen und je 2 Karten austeilen.
 * @returns {{ playerHand, dealerHand, deck }}
 */
export function startGame() {
  let deck = newShuffledDeck()
  let playerCard1, playerCard2, dealerCard1, dealerCard2

  ;({ card: playerCard1, remainingDeck: deck } = dealCard(deck))
  ;({ card: dealerCard1, remainingDeck: deck } = dealCard(deck))
  ;({ card: playerCard2, remainingDeck: deck } = dealCard(deck))
  ;({ card: dealerCard2, remainingDeck: deck } = dealCard(deck))

  return {
    playerHand: [playerCard1, playerCard2],
    dealerHand: [dealerCard1, dealerCard2],
    deck,
  }
}

/**
 * Dealer-Logik: zieht Karten bis der Wert ≥ 17 ist.
 * Wird von Petrit (REQ-002) verwendet.
 * @param {Array} hand  aktuelle Dealer-Hand
 * @param {Array} deck  verbleibendes Deck
 * @param {Function} calcScore  Score-Funktion aus gameLogic.js
 * @returns {{ hand, deck }}
 */
export function dealerPlay(hand, deck, calcScore) {
  let currentHand = [...hand]
  let currentDeck = [...deck]

  while (calcScore(currentHand) < 17) {
    const { card, remainingDeck } = dealCard(currentDeck)
    currentHand = [...currentHand, card]
    currentDeck = remainingDeck
  }

  return { hand: currentHand, deck: currentDeck }
}
