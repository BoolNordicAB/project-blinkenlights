Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)

# Load posh-git module from current directory
Import-Module .\Modules\posh-git\posh-git

# If module is installed in a default location ($env:PSModulePath),
# use this instead (see about_Modules for more information):
# Import-Module posh-git


# Set up a simple prompt, adding the git prompt parts inside git repos
function global:prompt {
    $realLASTEXITCODE = $LASTEXITCODE

    Write-Host
    Write-Host -NoNewLine -ForegroundColor White "["
    Write-Host $(Get-Date -Format "yy-MM-dd HH:mm") -BackgroundColor DarkGray -ForegroundColor Yellow -NoNewLine
    Write-Host " " -NoNewLine
    Write-Host ([Environment]::UserName) -NoNewLine -ForegroundColor Cyan
    Write-Host -NoNewLine -ForegroundColor Red "@"
    Write-Host  ([Environment]::MachineName + "." +
        [Environment]::UserDomainName) -NoNewLine -ForegroundColor Cyan
    Write-Host -NoNewLine -ForegroundColor White "::"
    Write-Host -NoNewLine $(Resolve-Path .) -ForegroundColor Green
    Write-Host -NoNewLine -ForegroundColor White "]"
    Write-Host -NoNewLine -ForegroundColor Magenta "$"
    #Write-VcsStatus
    Write-Host

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Pop-Location

Start-SshAgent -Quiet
