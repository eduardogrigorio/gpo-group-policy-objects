[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$WallpaperPath,

    [ValidateSet('Fill', 'Fit', 'Stretch', 'Tile', 'Center')]
    [string]$Style = 'Fill'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not (Test-Path -LiteralPath $WallpaperPath -PathType Leaf)) {
    throw "Wallpaper não encontrado ou sem acesso: $WallpaperPath"
}

$extension = [IO.Path]::GetExtension($WallpaperPath).ToLowerInvariant()
if ($extension -notin @('.jpg', '.jpeg', '.png', '.bmp')) {
    throw "Formato de wallpaper não permitido: $extension"
}

$styleMap = @{
    Fill    = @{ WallpaperStyle = '10'; TileWallpaper = '0' }
    Fit     = @{ WallpaperStyle = '6';  TileWallpaper = '0' }
    Stretch = @{ WallpaperStyle = '2';  TileWallpaper = '0' }
    Tile    = @{ WallpaperStyle = '0';  TileWallpaper = '1' }
    Center  = @{ WallpaperStyle = '0';  TileWallpaper = '0' }
}

$desktopKey = 'HKCU:\Control Panel\Desktop'
Set-ItemProperty -Path $desktopKey -Name Wallpaper -Value $WallpaperPath
Set-ItemProperty -Path $desktopKey -Name WallpaperStyle -Value $styleMap[$Style].WallpaperStyle
Set-ItemProperty -Path $desktopKey -Name TileWallpaper -Value $styleMap[$Style].TileWallpaper

# Atualiza os parâmetros visuais da sessão atual sem alterar políticas de segurança.
Add-Type @'
using System;
using System.Runtime.InteropServices;
public static class NativeMethods {
    [DllImport("user32.dll", CharSet = CharSet.Unicode)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
'@

[void][NativeMethods]::SystemParametersInfo(20, 0, $WallpaperPath, 3)
Write-Verbose "Wallpaper aplicado: $WallpaperPath ($Style)"
