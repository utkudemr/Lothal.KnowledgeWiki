# Usage:
#   .\scripts\save-ingest-summary.ps1 raw/tweets/2026-06-28-agent-harness-vs-classic-agent.md

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$SourcePath
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($SourcePath)) {
    Write-Error "Usage: .\scripts\save-ingest-summary.ps1 <raw-source-path>"
    exit 1
}

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path

if ([System.IO.Path]::IsPathRooted($SourcePath)) {
    $resolvedSourcePath = $SourcePath
} else {
    $resolvedSourcePath = Join-Path $root $SourcePath
}

if (-not (Test-Path -LiteralPath $resolvedSourcePath -PathType Leaf)) {
    Write-Error "Source file not found: $SourcePath"
    exit 1
}

$clipboardText = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardText)) {
    Write-Error "Clipboard is empty. Copy the ingest summary first."
    exit 1
}

$sourceSlug = [System.IO.Path]::GetFileNameWithoutExtension($resolvedSourcePath)
$runDirectory = Join-Path $root ".agent/runs/$sourceSlug"
$summaryPath = Join-Path $runDirectory 'ingest-summary.md'
$sourcePathFile = Join-Path $runDirectory 'source-path.txt'
$relativeSummaryPath = ".agent/runs/$sourceSlug/ingest-summary.md"

New-Item -ItemType Directory -Path $runDirectory -Force | Out-Null
Set-Content -LiteralPath $summaryPath -Value $clipboardText -Encoding UTF8 -NoNewline
Set-Content -LiteralPath $sourcePathFile -Value $SourcePath -Encoding UTF8 -NoNewline

Write-Output "Saved summary path: $relativeSummaryPath"
Write-Output "Source path: $SourcePath"
Write-Output "Next command:"
Write-Output ".\scripts\review-prompt.ps1 $SourcePath $relativeSummaryPath"
