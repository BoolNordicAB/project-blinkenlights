# $webUrl the url to the web containing the Lists
# $type the BaseTemplate type of the lists, e.g. PictureLibrary
# EXAMPLE: Remove-Lists http://contoso.com/site PictureLibrary
function Remove-Lists($webUrl, $type) {
  $web = get-spweb $webUrl
  $list = @()

  ## we can't delete directly from the .Lists collection since it's an enumeration
  ## so we'll append them all to the $list
  $web.Lists | foreach-object {
    if ($_.BaseTemplate -eq $type) {
      $list += $_
    }
  }

  $list | foreach-object {
    if ($_.BaseTemplate -eq $type) {
      $_.delete()
    }
  }
}
