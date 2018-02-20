#############################################
# remove application pool
#############################################

Get-help Install-WindowsFeature

Get-WindowsFeature


#############################################
# Install IIS (10.0)
#############################################

# The Restart parameter ( -Restart) automatically restarts the destination server if required by the role or feature installation.

Install-WindowsFeature -name Web-Server -IncludeManagementTools


#############################################
# Windows Server 2012
#############################################
Import-module servermanager

Add-windowsfeature web-server –includeallsubfeature
