[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^\\\\[^\\]+\\[^\\]+$')]
    [string]$PrinterPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Get-Command Add-Printer -ErrorAction SilentlyContinue)) {
    throw 'Add-Printer não está disponível neste endpoint.'
}

$existing = Get-Printer -Name $PrinterPath -ErrorAction SilentlyContinue
if ($null -ne $existing) {
    Write-Verbose "A impressora já está instalada: $PrinterPath"
    return
}

if ($PSCmdlet.ShouldProcess($PrinterPath, 'Adicionar impressora compartilhada')) {
    Add-Printer -ConnectionName $PrinterPath
    Write-Output "Impressora adicionada: $PrinterPath"
}
