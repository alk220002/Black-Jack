// REQ-001 | Msari Alkaabi
// Unit-Tests für das Deck-Modul (TST-001, TST-002, TST-003)

import { describe, it, expect } from 'vitest'
import { createDeck, shuffleDeck, dealCard, newShuffledDeck } from './deck'

// TST-001: Deck hat genau 52 Karten
describe('createDeck', () => {
  it('TST-001: erstellt genau 52 Karten', () => {
    const deck = createDeck()
    expect(deck).toHaveLength(52)
  })

  it('jede Karte hat suit und rank', () => {
    const deck = createDeck()
    deck.forEach(card => {
      expect(card).toHaveProperty('suit')
      expect(card).toHaveProperty('rank')
    })
  })

  it('alle 4 Farben vorhanden', () => {
    const deck = createDeck()
    const suits = [...new Set(deck.map(c => c.suit))]
    expect(suits).toHaveLength(4)
  })
})

// TST-002: shuffleDeck gibt 52 Karten zurück und ist nicht identisch
describe('shuffleDeck', () => {
  it('TST-002: gemischtes Deck hat dieselbe Länge', () => {
    const deck = createDeck()
    const shuffled = shuffleDeck(deck)
    expect(shuffled).toHaveLength(52)
  })

  it('originales Deck wird nicht verändert', () => {
    const deck = createDeck()
    const first = deck[0]
    shuffleDeck(deck)
    expect(deck[0]).toEqual(first)
  })
})

// TST-003: dealCard gibt die erste Karte und ein Deck mit 51 Karten zurück
describe('dealCard', () => {
  it('TST-003: gibt eine Karte und 51 verbleibende Karten zurück', () => {
    const deck = createDeck()
    const { card, remainingDeck } = dealCard(deck)
    expect(card).toBeDefined()
    expect(remainingDeck).toHaveLength(51)
  })

  it('ausgegebene Karte ist nicht mehr im verbleibenden Deck', () => {
    const deck = createDeck()
    const { card, remainingDeck } = dealCard(deck)
    expect(remainingDeck).not.toContainEqual(card)
  })
})

describe('newShuffledDeck', () => {
  it('gibt ein vollständiges Deck zurück', () => {
    expect(newShuffledDeck()).toHaveLength(52)
  })
})
