Import-Module WebAdministration 

$error.clear()

try
{
    #############################################
    # configuration variables
    #############################################
    $appPoolName = "LocalWempAppPool";
    $webSiteName = "LocalWemp";
    $webSitePath = "d:\publish\LocalWemp";

    $webSiteFullName = Join-Path IIS:\Sites\ $webSiteName
    $appPoolFullName = Join-Path IIS:\AppPools\ $appPoolName
    $angularSourcePath = "D:\tsf2\WEMP_TFS\Wontok.Wemp.Presentation" 

    Write-Host "$webSiteFullName" $webSiteFullName
    Write-Host "$appPoolFullName" $appPoolFullName


    #############################################
    # compile angular source
    #############################################
    cd $angularSourcePath

    invoke-command -scriptblock {ng build --prod}

    #############################################
    # copy local folder and file
    #############################################

    Write-Host "Remove local files"

    if(Test-Path $webSitePath)
    {
        Remove-Item $webSitePath -Recurse -Force
    }

    New-Item -ItemType Directory -Force -Path $webSitePath

    Copy-Item -Path .\dist\* -Destination $webSitePath -recurse -Force

    Copy-Item -Path D:\Backup\WempWebConfig\2018_01_17\web.config -Destination $webSitePath -recurse -Force
    

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

        Remove-WebAppPool "LocalWempAppPool"
    }


    #############################################
    # create application pool
    #############################################
    Write-Host "create app pool" $appPoolName

    New-WebAppPool -name $appPoolName  -force

    Set-ItemProperty -Path $appPoolFullName -Name managedRuntimeVersion -Value 'v4.0'


    #############################################
    # create web site
    #############################################
    Write-Host "create new web site"

    new-WebSite -name $webSiteName -PhysicalPath $webSitePath -ApplicationPool $appPoolName -force -Port 890


    #############################################
    # restart web site
    #############################################
    Stop-WebSite $webSiteName 
    Start-WebSite $webSiteName

    invoke-command -scriptblock {iisreset}

    cd $PSScriptRoot
}
catch
{
    Write-Host "Error!"
}