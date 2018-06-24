$TaskName = "ConsoleApplication1"
$SourcePath = "D:\GitHub\ConsoleApplication1\ConsoleApplication1\bin\Debug"
$TargetPath = "D:\ScheduledTasks\ConsoleApplication1"

# copy files from source to target
if(Test-Path $TargetPath)
{
    Remove-Item $TargetPath -Recurse -Force
}

New-Item -ItemType Directory -Force -Path $TargetPath

Copy-Item -Path $SourcePath\* -Destination $TargetPath -recurse -Force

# unregister task if exists already
$task = Get-ScheduledTask | Where-Object TaskName -EQ $TaskName

if ($task)
{
    $taskName = $task.TaskName

    Write-Output "Unregister task: $taskName" 

    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false
}

# register scheduled task

$action = New-ScheduledTaskAction -Execute $TargetPath\'ConsoleApplication1.exe' -WorkingDirectory $TargetPath
$trigger =  New-ScheduledTaskTrigger -Daily -At 1am
$settings = New-ScheduledTaskSettingsSet -MultipleInstances Parallel
Register-ScheduledTask  -Action $action `
                        -Trigger $trigger `
                        -TaskName $TaskName `
                        -Description $TaskName `
                        -RunLevel Highest `
                        -User localadmin `
                        -Password w0nt0k `
                        -Settings $settings `


