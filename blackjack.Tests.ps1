# ============================================================
#  Blackjack – Pester Testfaelle
#  Autoren : Msari, Petrit
#  Datum   : 2026-06-17
# ============================================================
# Ausfuehren mit:  Invoke-Pester .\blackjack.Tests.ps1 -Output Detailed
# ============================================================

BeforeAll {
    $scriptPath = Join-Path $PSScriptRoot "blackjack.ps1"
    $source = Get-Content $scriptPath -Raw
    # Interaktiven Spielloop entfernen, damit das Skript nicht startet
    $source = $source -replace '(?s)while\s*\(\$script:Coins\s*-gt\s*0\).*$', ''
    Invoke-Expression $source
}

# ============================================================
Describe "New-Deck" {

    It "enthaelt genau 52 Karten" {
        $deck = New-Deck
        $deck.Count | Should -Be 52
    }

    It "enthaelt jede Karte genau einmal" {
        $deck = New-Deck
        $unique = $deck | Select-Object -Property Rank, Suit -Unique
        $unique.Count | Should -Be 52
    }
}

# ============================================================
Describe "Get-HandScore Grundwerte" {

    It "berechnet zwei Zahlenkarten korrekt: 7 und 9 ergibt 16" {
        $hand = @(
            [pscustomobject]@{ Rank = "7"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "9"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 16
    }

    It "bewertet Bildkarten B und D mit je 10 Punkten ergibt 20" {
        $hand = @(
            [pscustomobject]@{ Rank = "B"; Suit = "Pik" },
            [pscustomobject]@{ Rank = "D"; Suit = "Kreuz" }
        )
        Get-HandScore $hand | Should -Be 20
    }

    It "erkennt Blackjack: Ass und Koenig ergibt 21" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "K"; Suit = "Pik" }
        )
        Get-HandScore $hand | Should -Be 21
    }
}

# ============================================================
Describe "Get-HandScore Ass-Logik" {

    It "zaehlt Ass als 11 wenn kein Bust entsteht: Ass und 7 ergibt 18" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "7"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 18
    }

    It "zaehlt Ass als 1 zurueck wenn sonst Bust: Ass 5 und 9 ergibt 15" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "5"; Suit = "Karo" },
            [pscustomobject]@{ Rank = "9"; Suit = "Pik" }
        )
        Get-HandScore $hand | Should -Be 15
    }

    It "behandelt zwei Asse korrekt: ergibt 12" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "A"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 12
    }
}

# ============================================================
Describe "Get-SuitSymbol" {

    It "gibt das richtige Symbol fuer Herz zurueck" {
        Get-SuitSymbol "Herz"  | Should -Be "♥"
    }

    It "gibt das richtige Symbol fuer Karo zurueck" {
        Get-SuitSymbol "Karo"  | Should -Be "♦"
    }

    It "gibt das richtige Symbol fuer Pik zurueck" {
        Get-SuitSymbol "Pik"   | Should -Be "♠"
    }

    It "gibt das richtige Symbol fuer Kreuz zurueck" {
        Get-SuitSymbol "Kreuz" | Should -Be "♣"
    }
}

# ============================================================
Describe "Get-SuitColor" {

    It "Herz hat Farbe Magenta" {
        Get-SuitColor "Herz"  | Should -Be "Magenta"
    }

    It "Karo hat Farbe Magenta" {
        Get-SuitColor "Karo"  | Should -Be "Magenta"
    }

    It "Pik hat Farbe White" {
        Get-SuitColor "Pik"   | Should -Be "White"
    }

    It "Kreuz hat Farbe White" {
        Get-SuitColor "Kreuz" | Should -Be "White"
    }
}

# ============================================================
Describe "New-Deck" {

    It "enthaelt genau 52 Karten" {
        $deck = New-Deck
        $deck.Count | Should -Be 52
    }

    It "enthaelt jede Karte genau einmal" {
        $deck = New-Deck
        $unique = $deck | Select-Object -Property Rank, Suit -Unique
        $unique.Count | Should -Be 52
    }
}

# ============================================================
Describe "Get-HandScore Grundwerte" {

    It "berechnet zwei Zahlenkarten korrekt: 7 und 9 ergibt 16" {
        $hand = @(
            [pscustomobject]@{ Rank = "7"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "9"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 16
    }

    It "bewertet Bildkarten B und D mit je 10 Punkten ergibt 20" {
        $hand = @(
            [pscustomobject]@{ Rank = "B"; Suit = "Pik" },
            [pscustomobject]@{ Rank = "D"; Suit = "Kreuz" }
        )
        Get-HandScore $hand | Should -Be 20
    }

    It "erkennt Blackjack: Ass und Koenig ergibt 21" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "K"; Suit = "Pik" }
        )
        Get-HandScore $hand | Should -Be 21
    }
}

# ============================================================
Describe "Get-HandScore Ass-Logik" {

    It "zaehlt Ass als 11 wenn kein Bust entsteht: Ass und 7 ergibt 18" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "7"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 18
    }

    It "zaehlt Ass als 1 zurueck wenn sonst Bust: Ass 5 und 9 ergibt 15" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "5"; Suit = "Karo" },
            [pscustomobject]@{ Rank = "9"; Suit = "Pik" }
        )
        Get-HandScore $hand | Should -Be 15
    }

    It "behandelt zwei Asse korrekt: ergibt 12" {
        $hand = @(
            [pscustomobject]@{ Rank = "A"; Suit = "Herz" },
            [pscustomobject]@{ Rank = "A"; Suit = "Karo" }
        )
        Get-HandScore $hand | Should -Be 12
    }
}

# ============================================================
Describe "Get-SuitSymbol" {

    It "gibt das richtige Symbol fuer Herz zurueck" {
        Get-SuitSymbol "Herz"  | Should -Be "♥"
    }

    It "gibt das richtige Symbol fuer Karo zurueck" {
        Get-SuitSymbol "Karo"  | Should -Be "♦"
    }

    It "gibt das richtige Symbol fuer Pik zurueck" {
        Get-SuitSymbol "Pik"   | Should -Be "♠"
    }

    It "gibt das richtige Symbol fuer Kreuz zurueck" {
        Get-SuitSymbol "Kreuz" | Should -Be "♣"
    }
}

# ============================================================
Describe "Get-SuitColor" {

    It "Herz hat Farbe Magenta" {
        Get-SuitColor "Herz"  | Should -Be "Magenta"
    }

    It "Karo hat Farbe Magenta" {
        Get-SuitColor "Karo"  | Should -Be "Magenta"
    }

    It "Pik hat Farbe White" {
        Get-SuitColor "Pik"   | Should -Be "White"
    }

    It "Kreuz hat Farbe White" {
        Get-SuitColor "Kreuz" | Should -Be "White"
    }
}
