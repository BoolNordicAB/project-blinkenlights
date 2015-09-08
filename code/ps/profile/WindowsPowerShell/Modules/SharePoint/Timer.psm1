function Run-SPTimerJobSynchronous(
  [Parameter(Mandatory=$true)][string]$webAppUrl,
  [Parameter(Mandatory=$true)][string]$timerJobName
)
{
  ## Find a timer job by its name, and the run it. Pausing script to wait for it to finish
  Write-Output "Trying to find timer job named $timerJobName"
  $timerJob = Get-SPTimerJob -WebApplication $webAppUrl | Where-Object { $_.Name -like $timerJobName }

  if ($timerJob -eq $null)
  {
    Write-Output "Could not find timer job $timerJobName, make sure it is installed."
    return
  }

  Write-Output "Found it"
  $lastRunEnded = $timerJob.LastRunTime

  Write-Output "Timerjob last started on $lastRunEnded"

  # Starting the timer job
  $timerJob | Start-SPTimerJob
  $now = Get-Date
  Write-Output "Now starting timer job, and the time is $now.`nPlease wait for it to finish"

  while ($timerJob.LastRunTime -eq $lastRunEnded)
  {
    # While the last runtime is the same as before, it should wait. This could go wrong if the job fails. Maybe
    Write-Host "." -NoNewline
    Start-Sleep -Seconds 1
  }

  Write-Output "."
  $newNow = Get-Date
  Write-Output "Finished timer job, and the time is $newNow"
}
