
<#
.SYNOPSIS
  Execute an XSL transform.

.DESCRIPTION
  Long description

.OUTPUTS
  The result of applying the specified transform.

.EXAMPLE
  transform.xsl:
  <xsl:transform version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:variable name="itemsA" select="document('a\items.xml')" />
    <xsl:variable name="itemsB" select="document('b\items.xml')" />

    <xsl:template match="/">
      <export>
        <xsl:copy-of select="$itemsA//item"/>
        <xsl:copy-of select="$itemsB//item"/>
      </export>
    </xsl:template>
  </xsl:transform>

  Execute-XslTransform transform.xsl output.xml

.LINK
  To other relevant cmdlets or help
#>
Function Execute-XslTransform
{
  [CmdletBinding()]
  [OutputType([Nullable])]
  Param
  (
    # Param1 help description
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=0)]
    $Xsl,

    # Param2 help description
    [Parameter(Mandatory, ValueFromPipelineByPropertyName, Position=1)]
    $Output
  )
  Begin
  {
    if (-not $xsl -or -not $output)
    {
      exit;
    }

    trap [Exception]
    {
      Write-Host $_.Exception;
    }

    $xsltSettings = New-Object System.Xml.Xsl.XsltSettings($true, $false);
    $xslt = New-Object System.Xml.Xsl.XslCompiledTransform;
    $xslt.Load("$pwd\$xsl", $xsltSettings, $null);
    $xslt.Transform("$pwd\$Xsl", "$pwd\$Output");

    Write-Host "generated" $Output;

  }
  Process
  {
  }
  End
  {
  }
}
