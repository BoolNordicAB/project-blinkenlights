# load SP module if not already loaded
if(-not(gsnp | ? { $_.Name -eq "Microsoft.SharePoint.PowerShell"})) { asnp Microsoft.SharePoint.PowerShell }


function private:InitSP()
{
  $profile_path = "$home\Documents\WindowsPowerShell\Modules"

  function im ($moduleName)
  {
    Import-Module "$profile_path\$moduleName.psm1" 3> $null
  }

  im "Server\Network"
}

InitSP
