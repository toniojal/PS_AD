do {
$user = Read-Host "'q' - poistu tai anna kayttajan nimi"
get-aduser -identity $user -properties passwordlastset | ft Name, passwordlastset
}
until ($user -eq "q")
