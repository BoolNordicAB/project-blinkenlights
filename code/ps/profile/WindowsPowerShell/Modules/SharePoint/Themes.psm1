
function Update-ThemesForWeb ($Url)
{
  $w = Get-SPWeb $Url
  [Microsoft.SharePoint.Utilities.SPTheme]::EnforceThemedStylesForWeb($w)
}
