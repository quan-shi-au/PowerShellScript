If (10 -gt 11)
{
	Write-Host "Yes"
} elseif( 11 -gt 10)
{
	Write-Host "This time, yes"
}

$numbers = 1

Do {
	
	$numbers = $numbers + 1
	
	Write-Host "The current value of the variable is $numbers"

} While ($numbers -lt 10)

$names = "Amy", "Bob", "Eunice"

$count = 0

ForEach ($singlename in $names) {
	$count += 1
	
	Write-Host $singlename
}