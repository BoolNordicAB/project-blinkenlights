function private:InitCommon()
{
  $profile_path = "$home\Documents\WindowsPowerShell\Modules"

  function im ($moduleName)
  {
    Import-Module "$profile_path\$moduleName.psm1" 3> $null
  }

  im "Server\Network"
}

InitCommon
