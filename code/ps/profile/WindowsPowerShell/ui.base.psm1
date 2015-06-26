Push-Location (Split-Path -Path $MyInvocation.MyCommand.Definition -Parent)


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
    Write-Host

    $global:LASTEXITCODE = $realLASTEXITCODE
    return "> "
}

Pop-Location
