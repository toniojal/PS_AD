
do {

$mail = Read-Host "Anna sähköpostiosoite tai poistu kirjoittamalla 'exit'"
Get-MsolUser -UserPrincipalName $mail | Format-List DisplayName,Licenses
}
until ($mail -eq "exit")