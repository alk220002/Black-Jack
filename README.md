# BlackJack – React

**Teammitglieder:** Msari Alkaabi · Petrit Suroji  
**Programmiersprache:** React (Vite + JavaScript)  
**Kurs:** MGIN – SW-Entwicklung

## Projekt starten

```bash
npm install
npm run dev        # Entwicklungsserver: http://localhost:5173
npm test           # Unit-Tests (Vitest)
npm run build      # Produktions-Build
npm run lint       # ESLint
```

## Anforderungen

| REQ-ID  | Beschreibung                                          | Zuständig        |
|---------|-------------------------------------------------------|------------------|
| REQ-001 | Deck, Spielzustand, UI-Komponenten, App-Orchestrierung | Msari Alkaabi    |
| REQ-002 | Score-Berechnung, Gewinner-Ermittlung, ScoreBoard     | Petrit Suroji    |

## Testfälle

| TST-ID  | REQ-ID  | Beschreibung                                      | Erwartetes Ergebnis |
|---------|---------|---------------------------------------------------|---------------------|
| TST-001 | REQ-001 | Deck hat genau 52 Karten                          | 52 Karten           |
| TST-002 | REQ-001 | Gemischtes Deck hat selbe Länge                   | 52 Karten           |
| TST-003 | REQ-001 | dealCard gibt 1 Karte + 51 verbleibende zurück    | card + 51 Karten    |
| TST-004 | REQ-002 | Normaler Handwert korrekt berechnet (10+8=18)     | 18                  |
| TST-005 | REQ-002 | Spieler-Bust → Ergebnis "bust"                    | "bust"              |
| TST-006 | REQ-002 | Spieler gewinnt bei höherem Score                 | "player"            |

## Git-Branches (GitFlow)

```
main           ← nur freigegebene Releases
develop        ← Integrationsbranch (Msaris Arbeit ist hier committed)
feature/REQ-002-score-und-ergebnis  ← Petrits Branch (noch nicht gemergt)
```

---

### Für Msari Alkaabi (pushen)

```bash
# Remote hinzufügen (einmalig):
git remote add origin https://github.com/DEIN-ACCOUNT/blackjack-react.git

# main und develop pushen:
git push -u origin main
git push -u origin develop
git push origin v0.1.0-msari        # Tag pushen
```

### Für Petrit Suroji (nach Übergabe dieser Dateien)

```bash
# 1. Repo clonen:
git clone https://github.com/MSARIS-ACCOUNT/blackjack-react.git
cd blackjack-react
npm install

# 2. Feature-Branch erstellen:
git checkout develop
git checkout -b feature/REQ-002-score-und-ergebnis

# 3. Petrits Dateien kopieren in:
#    src/utils/gameLogic.js
#    src/utils/gameLogic.test.js
#    src/components/ScoreBoard.jsx
#    src/components/ScoreBoard.css

# 4. Committen und pushen:
git add src/utils/gameLogic.js src/utils/gameLogic.test.js
git add src/components/ScoreBoard.jsx src/components/ScoreBoard.css
git commit -m "REQ-002 [feat] Petrit Suroji: Score-Berechnung, Gewinner-Logik, ScoreBoard-Komponente (TICKET-003)"
git tag -a v0.2.0-petrit -m "REQ-002 v0.2.0-petrit: Petrit Surojis Beitrag"
git push origin feature/REQ-002-score-und-ergebnis
git push origin v0.2.0-petrit

# 5. Merge Request auf develop stellen
```

## Entwicklungsumgebung

| Tool         | Version   |
|--------------|-----------|
| Node.js      | 22.x      |
| npm          | 10.x      |
| React        | 18.2      |
| Vite         | 5.x       |
| Vitest       | 1.x       |
| ESLint       | 8.x       |
