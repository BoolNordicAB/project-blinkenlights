# load SP module if not already loaded
if(-not(gsnp | ? { $_.Name -eq "Microsoft.SharePoint.PowerShell"})) { asnp Microsoft.SharePoint.PowerShell }
