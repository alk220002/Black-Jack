$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$script:Wins = 0
$script:Losses = 0
$script:Ties = 0
$script:Coins = 500

function Write-Separator {
    Write-Host ("-" * 52) -ForegroundColor DarkGray
}

function Write-Header {
    Clear-Host
    Write-Host ""
    Write-Host ("  Coins: {0,-5} Siege: {1,-3} Niederlagen: {2,-3} Unentschieden: {3}" -f $script:Coins, $script:Wins, $script:Losses, $script:Ties) -ForegroundColor Cyan
    Write-Separator
    Write-Host ""
}

function Get-SuitSymbol {
    param([string]$Suit)

    switch ($Suit) {
        "Herz" { return "H" }
        "Karo" { return "D" }
        "Pik" { return "S" }
        "Kreuz" { return "C" }
    }
}

function Get-SuitColor {
    param([string]$Suit)

    if ($Suit -in @("Herz", "Karo")) {
        return "Red"
    }
    return "White"
}

function New-Deck {
    $suits = @("Herz", "Karo", "Pik", "Kreuz")
    $ranks = @("2", "3", "4", "5", "6", "7", "8", "9", "10", "B", "D", "K", "A")
    $deck = @()

    foreach ($suit in $suits) {
        foreach ($rank in $ranks) {
            $deck += [pscustomobject]@{
                Rank = $rank
                Suit = $suit
            }
        }
    }

    return $deck | Get-Random -Count $deck.Count
}

function Get-HandScore {
    param([array]$Hand)

    $total = 0
    $aces = 0

    foreach ($card in $Hand) {
        switch ($card.Rank) {
            { $_ -in @("B", "D", "K") } { $total += 10; break }
            "A" { $total += 11; $aces++; break }
            default { $total += [int]$card.Rank }
        }
    }

    while ($total -gt 21 -and $aces -gt 0) {
        $total -= 10
        $aces--
    }

    return $total
}

function Draw-Card {
    param([ref]$Deck)

    $card = $Deck.Value[0]
    $Deck.Value = @($Deck.Value | Select-Object -Skip 1)
    return $card
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
            $card = $Hand[$i]
            $symbol = if ($hidden) { "?" } else { Get-SuitSymbol $card.Suit }
            $rank = if ($hidden) { "?" } else { $card.Rank }
            $color = if ($hidden) { "DarkGray" } else { Get-SuitColor $card.Suit }
            $rankText = $rank.PadRight(2)

            $text = switch ($line) {
                0 { "+-----+ " }
                1 { "|$rankText   | " }
                2 { "|  $symbol  | " }
                3 { "|   $rankText| " }
                4 { "+-----+ " }
            }
            Write-Host -NoNewline $text -ForegroundColor $color
        }
        Write-Host ""
    }
    Write-Host ""
}

function Read-Bet {
    while ($true) {
        Write-Header
        Write-Host "  Wie viele Coins willst du setzen?" -ForegroundColor White
        Write-Host "  Minimum: 1   Maximum: $script:Coins" -ForegroundColor DarkGray
        Write-Host ""

        $inputText = (Read-Host "  Einsatz").Trim()
        $bet = 0

        if ([int]::TryParse($inputText, [ref]$bet) -and $bet -ge 1 -and $bet -le $script:Coins) {
            return $bet
        }

        Write-Host "  Bitte gib eine Zahl zwischen 1 und $script:Coins ein." -ForegroundColor DarkYellow
        Start-Sleep -Milliseconds 1000
    }
}

function Finish-Round {
    param(
        [int]$Bet,
        [string]$Result,
        [string]$Message,
        [string]$Color
    )

    switch ($Result) {
        "Win" {
            $script:Coins += $Bet
            $script:Wins++
        }
        "Loss" {
            $script:Coins -= $Bet
            $script:Losses++
        }
        "Tie" {
            $script:Ties++
        }
    }

    Write-Separator
    Write-Host "  $Message" -ForegroundColor $Color

    if ($Result -eq "Win") {
        Write-Host "  +$Bet Coins" -ForegroundColor Green
    } elseif ($Result -eq "Loss") {
        Write-Host "  -$Bet Coins" -ForegroundColor Red
    } else {
        Write-Host "  Einsatz zurueck. Keine Coins verloren." -ForegroundColor DarkYellow
    }

    Write-Separator
}

function Play-Round {
    param([int]$Bet)

    $deck = @(New-Deck)
    $player = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))
    $dealer = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))

    while ($true) {
        Write-Header
        Write-Host "  Einsatz: $Bet Coins" -ForegroundColor Yellow
        Write-Host ""
        Show-Hand "Deine Karten" $player
        Show-Hand "Dealer       " $dealer -HideFirstCard

        $score = Get-HandScore $player
        if ($score -eq 21) {
            Write-Host "  Blackjack!" -ForegroundColor Yellow
            Write-Host ""
            break
        }

        Write-Separator
        Write-Host "  [Z] Karte ziehen   [H] Halten" -ForegroundColor White
        Write-Separator
        $answer = (Read-Host "  Deine Wahl").Trim().ToLower()

        if ($answer -eq "h") {
            break
        }

        if ($answer -ne "z") {
            Write-Host "  Bitte 'z' oder 'h' eingeben." -ForegroundColor DarkYellow
            Start-Sleep -Milliseconds 900
            continue
        }

        $player += Draw-Card ([ref]$deck)
        if ((Get-HandScore $player) -gt 21) {
            Write-Header
            Write-Host "  Einsatz: $Bet Coins" -ForegroundColor Yellow
            Write-Host ""
            Show-Hand "Deine Karten" $player
            Finish-Round $Bet "Loss" "Bust! Du bist ueber 21. Dealer gewinnt." "Red"
            return
        }
    }

    while ((Get-HandScore $dealer) -lt 17) {
        $dealer += Draw-Card ([ref]$deck)
    }

    $playerScore = Get-HandScore $player
    $dealerScore = Get-HandScore $dealer

    Write-Header
    Write-Host "  Einsatz: $Bet Coins" -ForegroundColor Yellow
    Write-Host ""
    Show-Hand "Deine Karten " $player
    Show-Hand "Dealer        " $dealer

    if ($dealerScore -gt 21) {
        Finish-Round $Bet "Win" "Dealer hat sich ueberkauft. Du gewinnst!" "Green"
    } elseif ($playerScore -gt $dealerScore) {
        Finish-Round $Bet "Win" "Du gewinnst!" "Green"
    } elseif ($playerScore -lt $dealerScore) {
        Finish-Round $Bet "Loss" "Dealer gewinnt." "Red"
    } else {
        Finish-Round $Bet "Tie" "Unentschieden." "DarkYellow"
    }
}

while ($script:Coins -gt 0) {
    $bet = Read-Bet
    Play-Round $bet

    if ($script:Coins -le 0) {
        Write-Host ""
        Write-Host "  Du hast keine Coins mehr." -ForegroundColor Red
        break
    }

    Write-Host ""
    Write-Host "  Nochmal spielen? " -ForegroundColor White -NoNewline
    Write-Host "[J/N]" -ForegroundColor Yellow
    $again = (Read-Host "  ").Trim().ToLower()
    if ($again -ne "j") {
        break
    }
}

Write-Header
Write-Host "  Endstand: $script:Coins Coins" -ForegroundColor Yellow
Write-Host "  Danke fuers Spielen!" -ForegroundColor White
Write-Host ""
