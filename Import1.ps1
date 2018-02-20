$ServicesFromFile = Import-csv test.csv

foreach ($services in $ServicesFromFile)
{
	Write-host $services
}	
	
$MyServices = get-service

$MyServices


$numberofcmdlets = (get-command).count

$numberofcmdlets


