#############################################
# check admin role
#############################################

# Get the ID and security principal of the current user account
$myWindowsID=[System.Security.Principal.WindowsIdentity]::GetCurrent()
$myWindowsPrincipal=new-object System.Security.Principal.WindowsPrincipal($myWindowsID)
 
# Get the security principal for the Administrator role
$adminRole=[System.Security.Principal.WindowsBuiltInRole]::Administrator
 
# Check to see if we are currently running "as Administrator"
if ($myWindowsPrincipal.IsInRole($adminRole))
   {
   # We are running "as Administrator" - so change the title and background color to indicate this
   $Host.UI.RawUI.WindowTitle = $myInvocation.MyCommand.Definition + "(Elevated)"
   $Host.UI.RawUI.BackgroundColor = "DarkBlue"
   clear-host
   }
else
   {
   # We are not running "as Administrator" - so relaunch as administrator
   
   # Create a new process object that starts PowerShell
   $newProcess = new-object System.Diagnostics.ProcessStartInfo "PowerShell";
   
   # Specify the current script path and name as a parameter
   $newProcess.Arguments = $myInvocation.MyCommand.Definition;
   
   # Indicate that the process should be elevated
   $newProcess.Verb = "runas";
   
   # Start the new process
   [System.Diagnostics.Process]::Start($newProcess);
   
   # Exit from the current, unelevated, process
   exit
}


#############################################
# start deployment
#############################################

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

#############################################
# Finished
#############################################
Read-Host -Prompt "Press any key to exit"
