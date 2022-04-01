do {
$kone = read-host "'q' - poistu tai Anna koneen nimi"
Get-ADComputer -Filter "Name -eq '$kone'" -Properties CN, CanonicalName, Created, LastLogonDate, Modified, whenCreated, whenChanged
}
until ($kone -eq "q")
