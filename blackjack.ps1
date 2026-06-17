$ErrorActionPreference = "Stop"

function New-Deck {
    $suits = @("Herz", "Karo", "Pik", "Kreuz")
    $ranks = @("2", "3", "4", "5", "6", "7", "8", "9", "10", "Bube", "Dame", "Koenig", "Ass")
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
            { $_ -in @("Bube", "Dame", "Koenig") } { $total += 10; break }
            "Ass" { $total += 11; $aces++; break }
            default { $total += [int]$card.Rank }
        }
    }

    while ($total -gt 21 -and $aces -gt 0) {
        $total -= 10
        $aces--
    }

    return $total
}

function Show-Hand {
    param(
        [string]$Name,
        [array]$Hand,
        [switch]$HideFirstCard
    )

    $parts = @()
    for ($i = 0; $i -lt $Hand.Count; $i++) {
        if ($HideFirstCard -and $i -eq 0) {
            $parts += "[verdeckt]"
        } else {
            $parts += "[$($Hand[$i].Rank) $($Hand[$i].Suit)]"
        }
    }

    if ($HideFirstCard) {
        Write-Host "$Name`: $($parts -join ' ')"
    } else {
        Write-Host "$Name`: $($parts -join ' ') = $(Get-HandScore $Hand)"
    }
}

function Draw-Card {
    param([ref]$Deck)

    $card = $Deck.Value[0]
    $Deck.Value = @($Deck.Value | Select-Object -Skip 1)
    return $card
}

function Play-Round {
    $deck = @(New-Deck)
    $player = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))
    $dealer = @((Draw-Card ([ref]$deck)), (Draw-Card ([ref]$deck)))

    while ($true) {
        Write-Host ""
        Show-Hand "Deine Karten" $player
        Show-Hand "Dealer" $dealer -HideFirstCard

        if ((Get-HandScore $player) -eq 21) {
            Write-Host "Blackjack!"
            break
        }

        $answer = (Read-Host "Karte ziehen oder halten? (z/h)").Trim().ToLower()
        if ($answer -eq "h") {
            break
        }
        if ($answer -ne "z") {
            Write-Host "Bitte z oder h eingeben."
            continue
        }

        $player += Draw-Card ([ref]$deck)
        if ((Get-HandScore $player) -gt 21) {
            Write-Host ""
            Show-Hand "Deine Karten" $player
            Write-Host "Du bist ueber 21. Dealer gewinnt."
            return
        }
    }

    while ((Get-HandScore $dealer) -lt 17) {
        $dealer += Draw-Card ([ref]$deck)
    }

    $playerScore = Get-HandScore $player
    $dealerScore = Get-HandScore $dealer

    Write-Host ""
    Show-Hand "Deine Karten" $player
    Show-Hand "Dealer" $dealer

    if ($dealerScore -gt 21) {
        Write-Host "Dealer ist ueber 21. Du gewinnst!"
    } elseif ($playerScore -gt $dealerScore) {
        Write-Host "Du gewinnst!"
    } elseif ($playerScore -lt $dealerScore) {
        Write-Host "Dealer gewinnt."
    } else {
        Write-Host "Unentschieden."
    }
}

Write-Host "Blackjack"
Write-Host "Ziel: Nah an 21 kommen, aber nicht darueber."

while ($true) {
    Play-Round
    Write-Host ""
    $again = (Read-Host "Nochmal spielen? (j/n)").Trim().ToLower()
    if ($again -ne "j") {
        Write-Host "Danke fuers Spielen!"
        break
    }
}
