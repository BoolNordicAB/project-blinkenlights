function Is-FeatureEnabledOnScope
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
