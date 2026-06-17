// REQ-002 | Petrit Suroji
// Unit-Tests für Score-Berechnung und Gewinner-Logik (TST-004, TST-005, TST-006)

import { describe, it, expect } from 'vitest'
import { calculateScore, determineWinner } from './gameLogic'

// TST-004: Score-Berechnung
describe('calculateScore', () => {
  it('TST-004: normaler Hand-Wert wird korrekt berechnet', () => {
    const hand = [{ rank: '10', suit: '♠' }, { rank: '8', suit: '♥' }]
    expect(calculateScore(hand)).toBe(18)
  })

  it('Bild-Karten zählen als 10', () => {
    const hand = [{ rank: 'K', suit: '♣' }, { rank: 'Q', suit: '♦' }]
    expect(calculateScore(hand)).toBe(20)
  })

  it('Ass + 10 = 21 (Blackjack)', () => {
    const hand = [{ rank: 'A', suit: '♠' }, { rank: 'K', suit: '♥' }]
    expect(calculateScore(hand)).toBe(21)
  })

  it('Ass wird auf 1 reduziert wenn > 21', () => {
    const hand = [
      { rank: 'A', suit: '♠' },
      { rank: 'K', suit: '♥' },
      { rank: '5', suit: '♦' },
    ]
    expect(calculateScore(hand)).toBe(16)
  })

  it('zwei Asse: einer als 11, einer als 1', () => {
    const hand = [{ rank: 'A', suit: '♠' }, { rank: 'A', suit: '♥' }]
    expect(calculateScore(hand)).toBe(12)
  })
})

// TST-005: Bust-Erkennung
describe('determineWinner – bust', () => {
  it('TST-005: Spieler-Bust → Ergebnis ist "bust"', () => {
    const player = [
      { rank: '10', suit: '♠' },
      { rank: '8', suit: '♥' },
      { rank: '5', suit: '♦' },
    ]
    const dealer = [{ rank: '10', suit: '♣' }, { rank: '7', suit: '♥' }]
    expect(determineWinner(player, dealer)).toBe('bust')
  })

  it('Dealer-Bust → Spieler gewinnt', () => {
    const player = [{ rank: '10', suit: '♠' }, { rank: '8', suit: '♥' }]
    const dealer = [
      { rank: '10', suit: '♣' },
      { rank: '7', suit: '♥' },
      { rank: '6', suit: '♦' },
    ]
    expect(determineWinner(player, dealer)).toBe('player')
  })
})

// TST-006: Gewinner-Logik
describe('determineWinner – normal', () => {
  it('TST-006: Spieler gewinnt bei höherem Score', () => {
    const player = [{ rank: '10', suit: '♠' }, { rank: '9', suit: '♥' }]
    const dealer = [{ rank: '10', suit: '♣' }, { rank: '7', suit: '♦' }]
    expect(determineWinner(player, dealer)).toBe('player')
  })

  it('Dealer gewinnt bei höherem Score', () => {
    const player = [{ rank: '10', suit: '♠' }, { rank: '6', suit: '♥' }]
    const dealer = [{ rank: '10', suit: '♣' }, { rank: '9', suit: '♦' }]
    expect(determineWinner(player, dealer)).toBe('dealer')
  })

  it('Unentschieden (push) bei gleichem Score', () => {
    const player = [{ rank: '10', suit: '♠' }, { rank: '8', suit: '♥' }]
    const dealer = [{ rank: '10', suit: '♣' }, { rank: '8', suit: '♦' }]
    expect(determineWinner(player, dealer)).toBe('push')
  })
})
