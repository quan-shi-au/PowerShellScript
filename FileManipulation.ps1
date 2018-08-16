$TargetPath="D:\Temp\TestFolder1"
$uniqueFolder=[guid]::NewGuid()
$RootBackupPath="D:\Temp\Backup"
$BackupPath="$RootBackupPath\$uniqueFolder"
$AppPoolName="Test"

# Stop the AppPool
if ((Get-WebAppPoolState $AppPoolName).Value -ne 'Stopped') {

    Write-Host "Shut Down App Pool - $AppPoolName..."
    
    Stop-WebAppPool -Name $AppPoolName

    if ((Get-WebAppPoolState $AppPoolName).Value -ne 'Stopped') {
        Start-Sleep -Seconds 1
    }

    Write-Host "$AppPoolName stopped."
}
else {
    Write-Host "$AppPoolName already stopped"
}


# remove historic backup files more than 5 days old
$cutOffDate = (Get-Date).AddDays(-5)
$AllFolders = Get-ChildItem -Path $RootBackupPath -Attributes Directory | Where-Object CreationTime -le $cutOffDate
$AllFolders | ForEach-Object {
    Write-Host "Remove historic backup folder: $RootBackupPath\$_"
    Remove-Item "$RootBackupPath\$_" -Recurse -Force
}

# copy files from Targetpath to backup, and remove it thereafter
if (Test-Path $TargetPath)
{
    Write-Host "Backup files from $TargetPath to $BackupPath"
    New-Item -ItemType Directory -Force -Path $BackupPath
    Copy-Item -Path "$TargetPath" -Destination "$BackupPath" -recurse -Force

    Write-Host "Remove files from $Targetpath..."
    Remove-Item "$TargetPath" -Recurse -Force
}
else 
{
    Write-Host "Error: $TargetPath doesnot exist"
}

# Start AppPool
if ((Get-WebAppPoolState $AppPoolName).Value -ne 'Started') {
    Start-WebAppPool -Name $AppPoolName

    while ((Get-WebAppPoolState $AppPoolName).Value -ne 'Started') {
        Start-Sleep -Seconds 1
    }
    Write-Host "AppPool $AppPoolName started."
}
else {
    Write-Host "AppPool $AppPoolName already started"
}
