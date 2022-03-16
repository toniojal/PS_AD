do {
$kayttaja = Read-Host "'Q' - poistu tai anna kayttajan nimi"
Get-ADUser -Filter "SamAccountName -eq '$kayttaja' -or Name -eq '$kayttaja'" -Properties *
}
until ($kayttaja -eq "q")
