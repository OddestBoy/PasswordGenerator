param (
    [Parameter()][Int32]$PasswordLength,
    [Parameter()][switch]$Admin,
    [Parameter()][Int32]$Bulk,
    [Parameter()][switch]$Stats,
    [Parameter()][switch]$CSV
)
$ErrorActionPreference = "stop"
if($CSV){
    $Folder = $PSScriptRoot
    try {
        Write-Output "Count,Password" | Out-File "$Folder\GeneratedPasswords.csv"
    }
    catch {
        Write-Host "Error writing to file $Folder\GeneratedPasswords.csv - $($PSItem.Exception.Message)"
        exit
    }

}
if(!$PasswordLength -or $PasswordLength -lt 5){
    if($Admin){
        $TargetLength = 20
    } else {
        $TargetLength = 10
    }
} else {
    $TargetLength = $PasswordLength
}
if($PasswordLength -and $PasswordLength -lt 5){
    Write-Warning "Password lengths below 5 characters are not supported. Defaulting to $TargetLength."
}

if($Bulk){
    $PWCountTarget = $Bulk
} else {
    $PWCountTarget = 1
}

#Remove lookalikes - I/l/1 - removed I/l, 0/O/o - removed O
$Uppers = @('A','B','C','D','E','F','G','H','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z')
$Lowers = @('a','b','c','d','e','f','g','h','i','j','k','m','n','o','p','q','r','s','t','u','v','w','x','y','z')
$Numbers = @(1,2,3,4,5,6,7,8,9)
$Symbols = @("!","?",".","+","-","%","@")
$Combined = $Symbols + $Numbers + $Lowers + $Uppers

function Choose-Random { #function to pick a random character from the choosen set
    param(
    [Parameter()][array]$Set
    )
    $Selection = get-random -Maximum ($Set.Length + 1)
    return $Set[$Selection]
}
if($Stats){$StartTime = Get-date}
$PWCount = 0
write-host ""
while($PWCount -lt $PWCountTarget){
    $Choices = "" #set character choices at 0
    #Make sure there is at least one of each
    $Choices = $Choices + (Choose-Random -Set $Uppers)
    $Choices = $Choices + (Choose-Random -Set $Lowers)
    $Choices = $Choices + (Choose-Random -Set $Numbers)
    $Choices = $Choices + (Choose-Random -Set $Symbols)
    #Fill up to target length with a mix of characters
    while($Choices.Length -lt $TargetLength){
        $Choices = $Choices + (Choose-Random -Set $Combined)
    }
    $Password = ($Choices -split '' | Sort-Object {get-random}) -join '' #Shuffle selected characters
    Write-Output "$Password"
    $PWCount += 1
    if($CSV){
        Write-Output "$PWCount,$Password" | Out-File "$Folder\GeneratedPasswords.csv" -Append
    }
}
if($Stats){
    $EndTime = Get-Date
    $TimeTaken = [math]::Round(($EndTime - $StartTime).TotalSeconds,4)
}
if($Stats){
    $TotalChoices = [Math]::Pow(($Uppers.Length + $Lowers.Length + $Numbers.Length + $Symbols.Length),$TargetLength)
    $Entropy = [math]::Round([Math]::Log2($TotalChoices),0) #password entropy is Log2(C^L) C is choices, L is length. 60+ is good
}
write-host ""
if($Stats){write-host "Generated $PWCountTarget $TargetLength character passwords in $TimeTaken seconds. Current config entropy $Entropy bits"}
if($CSV){Write-Host "Generated passwords output to $Folder\GeneratedPasswords.csv"}
write-host ""
