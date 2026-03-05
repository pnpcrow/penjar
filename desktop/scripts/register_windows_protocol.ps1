Param(
  [string]$Scheme = $env:PENJAR_WINDOWS_PROTOCOL_SCHEME,
  [string]$TargetPath = $env:PENJAR_WINDOWS_PROTOCOL_TARGET_PATH
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($Scheme)) {
  $Scheme = 'penjar'
}

if ([string]::IsNullOrWhiteSpace($TargetPath)) {
  throw 'PENJAR_WINDOWS_PROTOCOL_TARGET_PATH (or -TargetPath) must be set.'
}

$resolvedTargetPath = [System.IO.Path]::GetFullPath($TargetPath)
if (-not (Test-Path -LiteralPath $resolvedTargetPath)) {
  throw "Protocol target executable not found: $resolvedTargetPath"
}

$protocolRoot = "Registry::HKEY_CURRENT_USER\\Software\\Classes\\$Scheme"
$iconKey = "$protocolRoot\\DefaultIcon"
$commandKey = "$protocolRoot\\shell\\open\\command"

New-Item -Path $protocolRoot -Force -Value "URL:$Scheme Protocol" | Out-Null
New-ItemProperty -Path $protocolRoot -Name 'URL Protocol' -Value '' -PropertyType String -Force | Out-Null
New-Item -Path $iconKey -Force -Value ('"{0}",0' -f $resolvedTargetPath) | Out-Null

$launchCommand = ('"{0}" "%1"' -f $resolvedTargetPath)
New-Item -Path $commandKey -Force -Value $launchCommand | Out-Null

Write-Output "Registered URL protocol '$Scheme' for '$resolvedTargetPath' under HKCU."
