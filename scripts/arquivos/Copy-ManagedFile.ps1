[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$SourcePath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$DestinationPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $SourcePath -PathType Leaf)) {
    throw "Arquivo de origem não encontrado ou sem acesso: $SourcePath"
}

$destinationDirectory = Split-Path -Path $DestinationPath -Parent
if ([string]::IsNullOrWhiteSpace($destinationDirectory)) {
    throw 'O destino deve informar uma pasta.'
}

if (-not (Test-Path -LiteralPath $destinationDirectory -PathType Container)) {
    New-Item -Path $destinationDirectory -ItemType Directory -Force | Out-Null
}

$temporaryPath = "$DestinationPath.$([guid]::NewGuid().ToString('N')).tmp"
try {
    if ($PSCmdlet.ShouldProcess($DestinationPath, 'Copiar arquivo gerenciado')) {
        Copy-Item -LiteralPath $SourcePath -Destination $temporaryPath -Force
        Move-Item -LiteralPath $temporaryPath -Destination $DestinationPath -Force
        Write-Output "Arquivo atualizado: $DestinationPath"
    }
}
finally {
    if (Test-Path -LiteralPath $temporaryPath) {
        Remove-Item -LiteralPath $temporaryPath -Force -ErrorAction SilentlyContinue
    }
}
