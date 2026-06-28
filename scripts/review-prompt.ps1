# Usage examples:
#   .\scripts\review-prompt.ps1 raw/repos/aspire-agents-md.md
#   .\scripts\review-prompt.ps1 raw/articles/2026-06-20-example-source.md
#   .\scripts\review-prompt.ps1 raw/articles/2026-06-20-example-source.md .agent/runs/2026-06-20-example-source/ingest-summary.md

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$SourcePath,

    [Parameter(Mandatory = $false, Position = 1)]
    [string]$IngestSummaryPath
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$templatePath = Join-Path $root '.agent/prompts/review-ingest-output.md'
$resolvedSourcePath = Join-Path $root $SourcePath

if (-not (Test-Path -LiteralPath $resolvedSourcePath -PathType Leaf)) {
    Write-Error "Source file not found: $SourcePath"
    exit 1
}

if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    Write-Error "Review prompt template not found: $templatePath"
    exit 1
}

$template = Get-Content -LiteralPath $templatePath -Raw
$prompt = $template.Replace('{{SOURCE_PATH}}', $SourcePath)

if (-not [string]::IsNullOrWhiteSpace($IngestSummaryPath)) {
    if ([System.IO.Path]::IsPathRooted($IngestSummaryPath)) {
        $resolvedIngestSummaryPath = $IngestSummaryPath
    } else {
        $resolvedIngestSummaryPath = Join-Path $root $IngestSummaryPath
    }

    if (-not (Test-Path -LiteralPath $resolvedIngestSummaryPath -PathType Leaf)) {
        Write-Error "Ingest summary file not found: $IngestSummaryPath"
        exit 1
    }

    $ingestSummary = Get-Content -LiteralPath $resolvedIngestSummaryPath -Raw -Encoding UTF8
    $placeholderPattern = '(?m)^INGEST_OUTPUT\r?$'
    $placeholderRegex = [System.Text.RegularExpressions.Regex]::new($placeholderPattern)

    if (-not $placeholderRegex.IsMatch($prompt)) {
        Write-Error "INGEST_OUTPUT placeholder not found in review prompt template: $templatePath"
        exit 1
    }

    $prompt = $placeholderRegex.Replace(
        $prompt,
        [System.Text.RegularExpressions.MatchEvaluator]{ param($match) $ingestSummary },
        1
    )
}

Set-Clipboard -Value $prompt

if ([string]::IsNullOrWhiteSpace($IngestSummaryPath)) {
    Write-Output "Review prompt copied to clipboard for: $SourcePath"
} else {
    Write-Output "Review prompt generated with ingest summary included and copied to clipboard for: $SourcePath"
}
