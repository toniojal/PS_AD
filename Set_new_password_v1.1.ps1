<#
.SYNOPSIS
    Hakee halutun käyttäjän AD:lta ja resetoi tämän salasanan.
.Description
    Skripti kysyy AD:n käyttäjänimeä, kunnes haluttu käyttäjä löytyy AD:lta (Name tai SamAccountName).
    Tämän jälkeen pyytää kelvollista salasanaa kahteen kertaan. Salasanoja verrataan toisiinsa ja
    salasanojen ehdot tulee täyttyä. Salasanan pitää olla vähintään 10 merkkiä pitkä, sekä siinä on
    oltava erikoismerkkejä, isoja ja pieniä kirjaimia, sekä numeroita. Mikäli ehdot eivät täyty
    scripti ilmoittaa salasanan olevan kelvoton. Scripti tulostaa myös oleellisimmat tiedot käyttäjästä,
    kun käyttäjä löytyy. Scriptin alusta löytyy myös funktiomääritteet, jotka voidaan syöttää etukäteen
    "passwdchange":en.
.EXAMPLE
    PS> .\Set_new_password_v.1.1.ps1
.NOTES
    Author: Toni Ojala
    Date: 9.3.2022
#>

# Funktiomääritteet jotka voi halutessaan etukäteen määrittää
Function passwdchange {
    [CmdletBinding()]
    Param (
        [parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$user,
        [parameter(Mandatory=$true)][String]$NewPasswd,
        [parameter(Mandatory=$true)][String]$NewPasswdAgain
        
        )
}

# Haetaan käyttäjää AD:lta. Ellei löydy, niin kysyy sitä uudelleen, kunnes käyttäjä löytyy AD:lta.
do {
$user = Read-Host "Anna käyttajän nimi tai poistu painamalla 'q'"
$ExistingADUser = Get-ADUser -Filter "Name -eq '$user' -OR SamAccountName -eq '$user'"

# Mahdollisuus poistua scriptistä painamalla "q"
if ($user -eq "q")
{Write-Host "Poistuit scriptistä" -ForegroundColor Red
return $null}

elseif (!$ExistingADUser)
{
    Write-Host "Käyttäjää ei löytynyt AD:lta. Yritä uudelleen" -ForegroundColor Red
}

else

# Haetaan AD-käyttäjästä tietoja
{Write-Output "Käyttäjän tiedot ovat:" $ExistingADUser | fl -Property Name,SamAccountName,Enabled,UserPrincipalName}
}

until ($ExistingADUser)


# Syötetään salasana kahteen kertaan
do {
$NewPasswd = Read-Host "Anna kelvollinen salasana.
Salasanan oltava vähintään 10 merkkiä pitkä, sekä siinä on oltava erikoismerkkejä, isoja kirjaimia ja numeroita.
Poistu painamalla 'q'"

# Mahdollisuus poistua scriptistä painamalla "q"
if ($NewPasswd -eq "q")
{Write-Host "Poistuit scriptistä" -ForegroundColor Red
return $null}

else {}
$NewPasswdAgain = Read-Host "Anna salasana uudelleen"

# Määritetään salasanan ehdot. Vähintään 1 pieni ja iso kirjain, vähintään 1 erikoismerkki, pituus vähintään 10 merkkiä.
# Syötettyjen salasanojen on täsmättävä keskenään (katso edellinen kohta)
if ($t=(($NewPasswd -cmatch '[a-z]') `
-and ($NewPasswd -cmatch '[A-Z]') `
-and ($NewPasswd -ceq $NewPasswdAgain) `
-and ($NewPasswd.Length -ge 10) `
-and ($NewPasswd -contains '!'-or'@'-or'#'-or'%'-or'^'-or'&'-or'$'-or'?'-or'*')))

# Vaihdetaan salasana, mikäli ehdot täyttyvät
{
Set-ADAccountPassword $ExistingADUser -Reset -NewPassword (ConvertTo-SecureString -AsPlainText $NewPasswd -Force -Verbose) -PassThru -Confirm -WhatIf
Write-Host "Käyttäjän" $ExistingADUser.SamAccountName "salasana vaihdettu. Uusi salasana on:" $NewPasswd -ForegroundColor Green
}

else
# Mikäli salasana ei ole kelvollinen, ilmoittaa siitä ja kysyy salasanaa uudelleen 
{
    Write-Host "Salasana ei ole kelvollinen. Tarkista annettu salasanasi." -ForegroundColor Red
}

}
until ($t)
