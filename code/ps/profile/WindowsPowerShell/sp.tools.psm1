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
