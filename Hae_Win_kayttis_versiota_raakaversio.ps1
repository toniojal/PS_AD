<#
Version 21H2 (OS build 19044),Version 21H1 (OS build 19043),Version 20H2 (OS build 19042),Version 2004 (OS build 19041),Version 1909 (OS build 18363),Version 1903 (OS build 18362)
Version 1809 (OS build 17763),Version 1803 (OS build 17134),Version 1709 (OS build 16299),Version 1703 (OS build 15063),Version 1607 (OS build 14393),Version 1511 (OS build 10586) 
#> 


#"-- Huittinen Opiskelija --"
$lista= Get-ADComputer -Filter * -SearchBase "OU=HAYOH,OU=Oppilaitokset,OU=Tietokoneet,OU=SASKY,DC=edu,DC=sasky,DC=fi" -Properties * | select Name, Description, OperatingSystemVersion, Enabled
foreach ($llista in $lista)
     { 
       #$llista
      if ($llista.OperatingSystemVersion -lt "10.0 (19044)") {write-host $llista.name $llista.Description $llista.OperatingSystemVersion $llista.Enabled}
     }

