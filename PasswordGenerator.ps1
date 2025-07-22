param (
    [Parameter()][Int32]$TargetLength,
    [Parameter()][switch]$Admin,
    [Parameter()][Int32]$Bulk,
    [Parameter()][switch]$Stats
)

if(!$TargetLength){
    if($Admin){
        $TargetLength = 20
    } else {
        $TargetLength = 10
    }
}
if($Bulk){
    $PWCountTarget = $Bulk
} else {
    $PWCountTarget = 1
}
$Stats = $true
#Remove lookalikes - I/-l-/1, -0-/-O-/o,
$Uppers = @('A','B','C','D','E','F','G','H','I','J','K','L','M','N','P','Q','R','S','T','U','V','W','X','Y','Z')
$Lowers = @('a','b','c','d','e','f','g','h','i','j','k','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
$Numbers = @(1,2,3,4,5,6,7,8,9)
$Symbols = @("!","?",".","+","-")


function Choose-Random {
    param(
    [Parameter()][array]$Set
    )
    $Selection = Get-SecureRandom -Maximum ($Set.Length + 1)
    return $Set[$Selection]
}
if($Stats){$StartTime = Get-date}
$PWCount = 0
while($PWCount -lt $PWCountTarget){
    $Choices = "" #set character choices at 0
    #Make sure there is at least one of each
    $Choices = $Choices + (Choose-Random -Set $Uppers)
    $Choices = $Choices + (Choose-Random -Set $Lowers)
    $Choices = $Choices + (Choose-Random -Set $Numbers)
    $Choices = $Choices + (Choose-Random -Set $Symbols)
    #Fill up to target length with a mix of characters
    while($Choices.Length -lt $TargetLength){
        switch (Get-SecureRandom -Maximum 4){
            0 {$Choices = $Choices + (Choose-Random -Set $Uppers)}
            1 {$Choices = $Choices + (Choose-Random -Set $Lowers)}
            2 {$Choices = $Choices + (Choose-Random -Set $Numbers)}
            3 {$Choices = $Choices + (Choose-Random -Set $Symbols)}
        } 
    }
    $Password = ($Choices -split '' | Sort-Object {Get-SecureRandom}) -join ''
    Write-Output "$($PWCount+1) - $Password"
    $PWCount += 1
}
if($Stats){
    $EndTime = Get-Date
    $TimeTaken = [math]::Round(($EndTime - $StartTime).TotalSeconds,2)
}
if($Stats){
    $TotalChoices = [Math]::Pow(($Uppers.Length + $Lowers.Length + $Numbers.Length + $Symbols.Length),$TargetLength)
    $Entropy = [Math]::Log2($TotalChoices)
}
if($Stats){write-host "Generated $PWCountTarget $TargetLength character passwords in $TimeTaken seconds. Current config entropy $Entropy bits"}
