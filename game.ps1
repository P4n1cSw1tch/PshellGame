function displaytrack($track, $position) {
    cls
    for($i=0;$i -lt $position; $i++) {
        Write-Host -NoNewline " "
    }

    Write-Host -NoNewline "V"

    forEach($row in $track) {
        Write-Output("$row")
    }
}

function getNewPosition($position) {
    do {
        $key = [System.Console]::ReadKey($true)
    } while (($key.key -ne "LeftArrow") -and ($key.key -ne "RightArrow"))
    
    if ($key.key -eq "LeftArrow") {
        $position -= 1
    } elseif ($key.key -eq "RightArrow") {
        $position += 1
    }

    return $position
}

function checkBounds($position, $name) {
    if (($position -lt 0) -or ($position -gt 5)) {
        Write-Output("Game Over $name!")
        exit
    }
}

function racetrack($track) {
    
    $newtrack = @(
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", "")
    )

    for($i=0;$i -lt $newtrack.Length;$i++) {
        if (($i+1) -lt $track.Length) {
            $newtrack[$i] = $track[$i+1]
        }
    }

    return $newtrack
}


$track = @(
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "", ""),
    @("", "", "", "-", ""),
    @("", "-", "", "-", "")
)

$loop = $True
$isAlive = $True
$position = 3
$score = 1

$name = Read-Host("Enter Name")

While ($loop) {
    displaytrack $track $position
    $position = getNewPosition $position
    $isAlive = checkBounds $position $name
    $track = racetrack $track
}