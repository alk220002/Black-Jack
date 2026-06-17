$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# ── Statistik ────────────────────────────────────────────────────────────────
$script:Wins   = 0
$script:Losses = 0
$script:Ties   = 0

# ── Hilfsfunktionen ──────────────────────────────────────────────────────────
function Write-Separator {
    Write-Host ("─" * 52) -ForegroundColor DarkGray
}

function Write-Title {
    Clear-Host
    Write-Host ""
    Write-Host "  ██████╗ ██╗      █████╗  ██████╗██╗  ██╗     " -ForegroundColor Yellow
    Write-Host "  ██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝     " -ForegroundColor Yellow
    Write-Host "  ██████╔╝██║     ███████║██║     █████╔╝      " -ForegroundColor Yellow
    Write-Host "  ██╔══██╗██║     ██╔══██║██║     ██╔═██╗      " -ForegroundColor Yellow
    Write-Host "  ██████╔╝███████╗██║  ██║╚██████╗██║  ██╗     " -ForegroundColor Yellow
    Write-Host "  ╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝    " -ForegroundColor Yellow
    Write-Host "         ──  J A C K  ──                        " -ForegroundColor DarkYellow
    Write-Host ""
    Write-Separator
    Write-Host ("  Siege: {0,-4} Niederlagen: {1,-4} Unentschieden: {2}" -f $script:Wins, $script:Losses, $script:Ties) -ForegroundColor Cyan
    Write-Separator
    Write-Host ""
}

function Get-SuitSymbol {
    param([string]$Suit)
    switch ($Suit) {
        "Herz"  { return "♥" }
        "Karo"  { return "♦" }
        "Pik"   { return "♠" }
        "Kreuz" { return "♣" }
    }
}

function Get-SuitColor {
    param([string]$Suit)
    if ($Suit -in @("Herz", "Karo")) { return "Red" } else { return "White" }
}

# ── Karten ────────────────────────────────────────────────────────────────────
function New-Deck {
    $suits = @("Herz", "Karo", "Pik", "Kreuz")
    $ranks = @("2","3","4","5","6","7","8","9","10","B","D","K","A")
    $deck  = @()
    foreach ($suit in $suits) {
        foreach ($rank in $ranks) {
            $deck += [pscustomobject]@{ Rank = $rank; Suit = $suit }
        }
    }
    return $deck | Get-Random -Count $deck.Count
}

function Get-HandScore {
    param([array]$Hand)
    $total = 0
    $aces  = 0
    foreach ($card in $Hand) {
        switch ($card.Rank) {
            { $_ -in @("B","D","K") } { $total += 10; break }
            "A" { $total += 11; $aces++; break }
            default { $total += [int]$card.Rank }
        }
    }
    while ($total -gt 21 -and $aces -gt 0) { $total -= 10; $aces-- }
    return $total
}

function Draw-Card {
    param([ref]$Deck)
    $card       = $Deck.Value[0]
    $Deck.Value = @($Deck.Value | Select-Object -Skip 1)
    return $card
}

# ── Kartenanzeige als ASCII-Karte ─────────────────────────────────────────────
function Show-CardLine {
    param([array]$Cards, [int]$Line, [switch]$HideFirst)

    $parts = @()
    for ($i = 0; $i -lt $Cards.Count; $i++) {
        $hidden = ($HideFirst -and $i -eq 0)
        $card   = $Cards[$i]
        $sym    = if ($hidden) { "?" } else { Get-SuitSymbol $card.Suit }
        $rank   = if ($hidden) { "?" } else { $card.Rank }
        $r      = $rank.PadRight(2)

        switch ($Line) {
            0 { $parts += "┌─────┐" }
            1 { $parts += "│$r   │" }
            2 { $parts += "│  $sym  │" }
            3 { $parts += "│   $r│" }
            4 { $parts += "└─────┘" }
        }
        # Farbe wird separat gesetzt – wir sammeln nur Texte
    }
    return $parts
}

function Show-Hand {
    param(
        [string]$Name,
        [array]$Hand,
        [switch]$HideFirstCard
    )

    $label = if ($HideFirstCard) { $Name } else { "$Name  [Punkte: $(Get-HandScore $Hand)]" }
    Write-Host "  $label" -ForegroundColor Cyan

    for ($line = 0; $line -le 4; $line++) {
        Write-Host -NoNewline "  "
        for ($i = 0; $i -lt $Hand.Count; $i++) {
            $hidden = ($HideFirstCard -and $i -eq 0)
            $card   = $Hand[$i]
            $sym    = if ($hidden) { "?" } else { Get-SuitSymbol $card.Suit }
            $rank   = if ($hidden) { "?" } else { $card.Rank }
            $color  = if ($hidden) { "DarkGray" } else { Get-SuitColor $card.Suit }
            $r      = $rank.PadRight(2)

            $text = switch ($line) {
                0 { "┌─────┐ " }
                1 { "│$r   │ " }
                2 { "│  $sym  │ " }
                3 { "│   $r│ " }
                4 { "└─────┘ " }
            }
            Write-Host -NoNewline $text -ForegroundColor $color
        }
        Write-Host ""
    }
    Write-Host ""
}

# ── Spielrunde ────────────────────────────────────────────────────────────────
function Play-Round {
    $deck   = @(New-Deck)
    $player = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))
    $dealer = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))

    # Spielerzug
    while ($true) {
        Write-Title
        Show-Hand "Deine Karten" $player
        Show-Hand "Dealer       " $dealer -HideFirstCard

        $score = Get-HandScore $player
        if ($score -eq 21) {
            Write-Host "  ★ BLACKJACK! ★" -ForegroundColor Yellow
            Write-Host ""
            break
        }

        Write-Separator
        Write-Host "  [Z] Karte ziehen   [H] Halten" -ForegroundColor White
        Write-Separator
        $answer = (Read-Host "  Deine Wahl").Trim().ToLower()

        if ($answer -eq "h") { break }

        if ($answer -ne "z") {
            Write-Host "  Bitte 'z' oder 'h' eingeben." -ForegroundColor DarkYellow
            Start-Sleep -Milliseconds 900
            continue
        }

        $player += Draw-Card ([ref]$deck)
        if ((Get-HandScore $player) -gt 21) {
            Write-Title
            Show-Hand "Deine Karten" $player
            Write-Host "  Bust! Du bist ueber 21." -ForegroundColor Red
            Write-Host "  Dealer gewinnt." -ForegroundColor Red
            $script:Losses++
            return
        }
    }

    # Dealerzug
    while ((Get-HandScore $dealer) -lt 17) {
        $dealer += Draw-Card ([ref]$deck)
    }

    $playerScore = Get-HandScore $player
    $dealerScore = Get-HandScore $dealer

    Write-Title
    Show-Hand "Deine Karten " $player
    Show-Hand "Dealer        " $dealer

    Write-Separator

    if ($dealerScore -gt 21) {
        Write-Host "  Dealer hat sich ueberkauft. Du gewinnst!" -ForegroundColor Green
        $script:Wins++
    } elseif ($playerScore -gt $dealerScore) {
        Write-Host "  Du gewinnst!" -ForegroundColor Green
        $script:Wins++
    } elseif ($playerScore -lt $dealerScore) {
        Write-Host "  Dealer gewinnt." -ForegroundColor Red
        $script:Losses++
    } else {
        Write-Host "  Unentschieden." -ForegroundColor DarkYellow
        $script:Ties++
    }
    Write-Separator
}

# ── Einstieg ──────────────────────────────────────────────────────────────────
Write-Title
Write-Host "  Ziel: Nahe an 21 kommen, ohne darueber zu gehen." -ForegroundColor Gray
Write-Host "  Bildkarten zaehlen 10, Ass zaehlt 11 oder 1." -ForegroundColor Gray
Write-Host ""

while ($true) {
    Play-Round
    Write-Host ""
    Write-Host "  Nochmal spielen? " -ForegroundColor White -NoNewline
    Write-Host "[J/N]" -ForegroundColor Yellow
    $again = (Read-Host "  ").Trim().ToLower()
    if ($again -ne "j") {
        Write-Title
        Write-Host "  Danke fuers Spielen! Auf Wiedersehen." -ForegroundColor Yellow
        Write-Host ""
        break
    }
}
