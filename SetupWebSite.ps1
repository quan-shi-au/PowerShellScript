Import-Module WebAdministration 

#############################################
# configuration variables
#############################################
$appPoolName = "NewWebSiteAppPool";
$webSiteName = "NewWebSite";
$webSitePath = "d:\publish\NewWebSite";
$webHostName = "www.newwebsite.com"

$webSiteFullName = Join-Path IIS:\Sites\ $webSiteName
$appPoolFullName = Join-Path IIS:\AppPools\ $appPoolName
$indexFilePath = Join-Path $webSitePath "\index.html"
 

Write-Host "$webSiteFullName" $webSiteFullName
Write-Host "$appPoolFullName" $appPoolFullName

#############################################
# remove web site if already exists
#############################################

if(Test-Path $webSiteFullName)
{
    Write-Host "Website exists - removing"

    Get-WebSite -Name $webSiteName | Remove-WebSite -Confirm:$false -Verbose
}

#############################################
# remove application pool
#############################################
cd IIS:\AppPools\

if (Test-Path $appPoolName -pathType container ) 
{
    Write-Host "AppPool already exists - removing"

    Remove-WebAppPool "NewWebSiteAppPool"
}


#############################################
# create application pool
#############################################
Write-Host "create app pool" $appPoolName

New-WebAppPool -name $appPoolName  -force

Set-ItemProperty -Path IIS:\AppPools\NewWebSiteAppPool -Name managedRuntimeVersion -Value 'v4.0'


#############################################
# create web site
#############################################
new-WebSite -name $webSiteName -PhysicalPath $webSitePath -ApplicationPool $appPoolName -HostHeader $webHostName -force

#New-Website -name $webSiteName -PhysicalPath $webSitePath -ApplicationPool "CoolWebSite" -HostHeader $deployUrl


#############################################
# create local folder and file
#############################################
Write-Host "create index.html"

New-Item -ItemType Directory -Force -Path $webSitePath
New-Item -ItemType File -Force -Path $indexFilePath


#############################################
# restart web site
#############################################
Stop-WebSite $webSiteName 
Start-WebSite $webSiteName

invoke-command -scriptblock {iisreset}

cd $PSScriptRoot