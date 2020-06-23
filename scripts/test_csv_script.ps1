$a = get-content "C:\x.txt"

foreach($x in $a)

{

$j = get-aduser -filter {samaccountname -eq $x} -Properties givenname,sn,displayname,samaccountname

$j | Select-Object -Property givenname, sn, displayname, samaccountname

}