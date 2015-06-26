###############################################################################
#
# Profile start script
#
###############################################################################

function private:InitProfile()
{
	$profile_path = "$home\Documents\WindowsPowerShell"

	function im ($moduleName)
	{
		Import-Module "$profile_path\$moduleName.psm1" 3> $null
	}

	# Import our custom modules.
	im "ui.base" # don't use with cmder
	im "sp.init"
	im "sp.tools"

	Import-Module "PowerTab"

	Write-Host " ___________ "
	Write-Host "/  ___| ___ \"
	Write-Host "\ '--.| |_/ /"
	Write-Host " '--. \  __/ "
	Write-Host "/\__/ / |    "
	Write-Host "\____/\_|    "
	Write-Host
}

InitProfile
