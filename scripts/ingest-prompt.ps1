# Usage examples:
#   .\scripts\ingest-prompt.ps1 raw/repos/aspire-agents-md.md
#   .\scripts\ingest-prompt.ps1 raw/articles/2026-06-20-example-source.md

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$SourcePath
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$templatePath = Join-Path $root '.agent/prompts/ingest-source.md'
$resolvedSourcePath = Join-Path $root $SourcePath

if (-not (Test-Path -LiteralPath $resolvedSourcePath -PathType Leaf)) {
    Write-Error "Source file not found: $SourcePath"
    exit 1
}

if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    Write-Error "Ingest prompt template not found: $templatePath"
    exit 1
}

$template = Get-Content -LiteralPath $templatePath -Raw
$prompt = $template.Replace('{{SOURCE_PATH}}', $SourcePath)

Set-Clipboard -Value $prompt

Write-Output "Ingest prompt copied to clipboard for: $SourcePath"
