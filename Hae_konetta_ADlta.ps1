do {
$kone = read-host "'q' - poistu tai Anna koneen nimi"
Get-ADComputer -identity $kone
}
until ($kone -eq "q")