function WaitForSPSolutionJobToComplete([string]$solutionName)
{
  $solution = Get-SPSolution -Identity $solutionName -ErrorAction SilentlyContinue
  if ($solution)
  {
    if ($solution.JobExists)
    {
      Write-Host -NoNewLine "Waiting for timer job to complete for solution '$solutionName'."
    }
    # Check if there is a timer job still associated with this solution and wait until it has finished
    while ($solution.JobExists)
    {
      $jobStatus = $solution.JobStatus
      # If the timer job succeeded then proceed
      if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Succeeded)
      {
        Write-Host "Solution '$solutionName' timer job succeeded" -ForegroundColor Green
        return $true
      }
      # If the timer job failed or was aborted then fail
      if ($jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Aborted -or
          $jobStatus -eq [Microsoft.SharePoint.Administration.SPRunningJobStatus]::Failed)
      {
        Write-Host "Solution '$solutionName' has timer job status '$jobStatus'." -ForegroundColor Red
        return $false
      }
      # Otherwise wait for the timer job to finish
      Write-Host -NoNewLine "."
      Sleep 1
    }
    # Write a new line to the end of the '.....'
    Write-Host
  }
  return $true
}

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

function ReDeploySolution($SolutionName, $ForWebApp)
{
  UnDeploySolution $SolutionName $ForWebApp
  DeploySolution $SolutionName $ForWebApp
}

function UnDeploySolution($SolutionName, $ForWebApp)
{
  if ($ForWebApp)
  {
    Uninstall-SPSolution $SolutionName -Confirm:$false -WebApplication $ForWebApp
    WaitForSPSolutionJobToComplete $SolutionName
  }
  else
  {
    Uninstall-SPSolution $SolutionName -Confirm:$false
    WaitForSPSolutionJobToComplete $SolutionName
  }

  Remove-SPSolution $SolutionName -Confirm:$false
  WaitForSPSolutionJobToComplete $SolutionName
}

function DeploySolution($SolutionName, $ForWebApp)
{
  $path = Resolve-Path .

  Add-SPSolution "$path\$SolutionName" -Confirm:$false
  WaitForSPSolutionJobToComplete $SolutionName

  if ($ForWebApp)
  {
    Install-SPSolution $SolutionName -GACDeployment -WebApplication $ForWebApp -Confirm:$false
    WaitForSPSolutionJobToComplete $SolutionName
  }
  else
  {
    Install-SPSolution $SolutionName -GACDeployment -Confirm:$false
    WaitForSPSolutionJobToComplete $SolutionName
  }
}

function RemoveAllSitesUnderManagedPath($WebAppUrl, $ManagedPath)
{
  $sites = Get-SPSite -Identity "$WebAppUrl/$ManagedPath/*" -Limit All
  foreach($s in $sites)
  {
    Write-Host "Removing $($s.Url)"
    Remove-SPSite $s -Confirm:$false
  }
}

function ProvisionTheme ($Url)
{
  $w = Get-SPWeb $Url
  [Microsoft.SharePoint.Utilities.SPTheme]::EnforceThemedStylesForWeb($w)
}

function RestartNetwork ()
{
  iisreset /noforce
  net stop sptimerv4
  net start sptimerv4
}

function isFeatureEnabledOnScope
(
    [Parameter(Mandatory=$true)][string]$name,
    [Parameter(Mandatory=$true)][string]$url,
    [Parameter(Mandatory=$true)][string]$scope
)
{
  if($scope -eq "Farm")
  {
    $params = @{
      'Identity'            = $featureObject.Name;
      'ErrorAction'         = 'SilentlyContinue';
    }

    $featureIsEnabled = (Get-SPFeature @params -Farm) -ne $null
  }
  else
  {
    $params = @{
      'Identity'            = $featureObject.Name;
      'ErrorAction'         = 'SilentlyContinue';
      $featureObject.Scope  = $webAppUrl
    }

    $featureIsEnabled = (Get-SPFeature @params) -ne $null
  }

  return $featureIsEnabled
}
