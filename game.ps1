# Function to set cursor position
function Set-CursorPosition($left, $top) {
    $host.UI.RawUI.CursorPosition = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $left, $top
}

# Function to display the racetrack and player position
function DisplayTrack($track) {
    clear

    foreach ($row in $track) {
        Write-Output("$row")
    }
}

function DisplayPlayer($position) {
    Set-CursorPosition -Left $position -Top 0
    Write-Output("V")
}

function HitObstacle($row, $position, $score, $name) {
    $hitObstacle = $False

    if ($row[$position] -eq "*") {
        $hitObstacle = $True
        clear
        Write-Output "Game Over $name!"
        Write-Output "Your Score Was $score!"
        exit
    }

    return $hitObstacle
}

# Function to get the new player position based on user inputs
function GetNewPosition($position) {
    do {
        $key = [System.Console]::ReadKey($true).Key
    } while (($key -ne "LeftArrow") -and ($key -ne "RightArrow"))

    if ($key -eq "LeftArrow") {
        $position -= 1
    } elseif ($key -eq "RightArrow") {
        $position += 1
    }

    return $position
}

# Function to check if the player is within the bounds of the racetrack
function CheckBounds($position, $name, $score) {
    if (($position -lt 0) -or ($position -gt $raceTrackWidth)) {
        clear
        Write-Output "Game Over $name!"
        Write-Output "Your Score Was $score!"
        exit
    }
}

# Function to update the racetrack by shifting rows up
function RaceTrack($track, $row) {
    $newTrack = @(
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
       @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
    )

    for ($i = 0; $i -lt $newTrack.Length; $i++) {
        # Copy the next row from the original track to the new track
        if (($i + 1) -lt $track.Length) {
            $newTrack[$i] = $track[$i + 1]
        }
    }

    $newTrack[-1] = generateobstacles

    return $newTrack
}

function generateobstacles {
    $row = @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")

    $Obstacle1 = Get-Random -Minimum 0 -Maximum 29
    $row[$Obstacle1] = "*"

    return $row
}

# Global variables
$loop = $true
$isAlive = $true
$position = 15
$score = 1
$raceTrackWidth = 30

# Initialize racetrack and game variables
$track = @(
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""),
    @("", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
    )

# Prompt the player to enter their name
$name = Read-Host "Enter Name"

# Start the timer
$timer = [System.Diagnostics.Stopwatch]::StartNew() # Start the timer

# Main game loop
while ($loop) {
    DisplayTrack $track    # Display the racetrack
    $timeLeft = 30 - [math]::Floor($timer.Elapsed.TotalSeconds)    # Calculate the time left until 30 seconds

    # Display the remaining time
    Write-Output "Time Left: $timeLeft seconds"
    DisplayPlayer $position    # Display the player
    $row = generateobstacles
    $position = GetNewPosition $position    # Get the new player position
    $isAlive = CheckBounds $position $name $score    # Check if the player is within bounds
    $score += 1
    $track = RaceTrack $track $row    # Update the racetrack
    $isAlive = HitObstacle $track[0] $position $score $name    # Check if the player hit an obstacle
    if ($timer.Elapsed.TotalSeconds -ge 30) {    # Check if the game time is over
        clear
        Write-Output "Game Over $name!"
        Write-Output "Your Score Was $score!"
        exit
    }
}
