
function Remove-AllSitesUnderManagedPath($WebAppUrl, $ManagedPath)
{
  $sites = Get-SPSite -Identity "$WebAppUrl/$ManagedPath/*" -Limit All
  foreach($s in $sites)
  {
    Write-Host "Removing $($s.Url)"
    Remove-SPSite $s -Confirm:$false
  }
}
