
Function passwdchange {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true, ValueFromPipeline)][String]$user,
        [parameter(Mandatory=$true)][String]$NewPasswd,
        [parameter(Mandatory=$true)][String]$NewPasswdAgain
        
        )
}

$user = Read-Host "Anna käyttajän nimi"
$ExistingADUser = Get-ADUser -Filter "Name -eq '$user' -OR SamAccountName -eq '$user'"
if ($null -eq $ExistingADUser)
{
    Write-Host "Käyttäjää ei löytynyt AD:lta. Scripti sulkeutuu" -ForegroundColor Red
    return $null
}

else 

{Write-Output "Käyttäjän tiedot ovat:" $ExistingADUser | fl -Property Name,SamAccountName,Enabled,UserPrincipalName}

$NewPasswd = Read-Host "Anna kelvollinen salasana. Salasanan oltava vähintään 10 merkkiä pitkä, sekä siinä on oltava erikoismerkkejä, isoja kirjaimia ja numeroita"
$NewPasswdAgain = Read-Host "Anna salasana uudelleen"

if (($NewPasswd -cmatch '[a-z]') `
-and ($NewPasswd -cmatch '[A-Z]') `
-and ($NewPasswd -ceq $NewPasswdAgain) `
-and ($NewPasswd.Length -ge 10) `
-and ($NewPasswd -contains '!'-or'@'-or'#'-or'%'-or'^'-or'&'-or'$'-or'?'-or'*'))

{
Set-ADAccountPassword $ExistingADUser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $NewPasswd -Force -Verbose) -PassThru -Confirm -WhatIf
Write-Host "Käyttäjän" $ExistingADUser.SamAccountName "salasana vaihdettu. Uusi salasana on:" $NewPasswd -ForegroundColor Green
}

else 
{
    Write-Host "Salasana ei ole kelvollinen. Tarkista annettu salasanasi." -ForegroundColor Red
    return $null
}