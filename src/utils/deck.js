// REQ-001 | Msari Alkaabi
// Deck-Erstellung, Mischen und Kartenausgabe

const SUITS = ['♠', '♥', '♦', '♣']
const RANKS = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K']

/**
 * Erstellt ein vollständiges 52-Karten-Deck.
 * @returns {Array<{suit: string, rank: string}>}
 */
export function createDeck() {
  const deck = []
  for (const suit of SUITS) {
    for (const rank of RANKS) {
      deck.push({ suit, rank })
    }
  }
  return deck
}

/**
 * Mischt ein Deck mit dem Fisher-Yates-Algorithmus (in-place).
 * @param {Array} deck
 * @returns {Array} das gemischte Deck
 */
export function shuffleDeck(deck) {
  const d = [...deck]
  for (let i = d.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1))
    ;[d[i], d[j]] = [d[j], d[i]]
  }
  return d
}

/**
 * Gibt die oberste Karte zurück und entfernt sie aus dem Deck.
 * @param {Array} deck
 * @returns {{ card: object, remainingDeck: Array }}
 */
export function dealCard(deck) {
  const [card, ...remainingDeck] = deck
  return { card, remainingDeck }
}

/**
 * Erstellt und mischt ein neues Deck.
 * @returns {Array}
 */
export function newShuffledDeck() {
  return shuffleDeck(createDeck())
}
