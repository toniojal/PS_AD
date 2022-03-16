do {
$kayttaja = Read-Host "'q' - poistu tai anna kayttajan SamAccount"
Get-ADUser -Filter "SamAccountName -eq '$kayttaja'" -Properties * | select SamAccountName

Get-ADPrincipalGroupMembership $kayttaja

}
until ($kayttaja -eq "q")

