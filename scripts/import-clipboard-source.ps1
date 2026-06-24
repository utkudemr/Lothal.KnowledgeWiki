# Usage:
#   .\scripts\import-clipboard-source.ps1 raw/articles/2026-06-23-example.md

param(
    [Parameter(Mandatory = $false, Position = 0)]
    [string]$SourcePath
)

$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($SourcePath)) {
    Write-Error "Usage: .\scripts\import-clipboard-source.ps1 <raw-source-path>"
    exit 1
}

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path

if ([System.IO.Path]::IsPathRooted($SourcePath)) {
    $targetPath = $SourcePath
} else {
    $targetPath = Join-Path $root $SourcePath
}

if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
    Write-Error "Source file not found: $SourcePath"
    exit 1
}

$clipboardText = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardText)) {
    Write-Error "Clipboard is empty or whitespace. Copy article markdown/text first, then run this script again."
    exit 1
}

$content = Get-Content -LiteralPath $targetPath -Raw -Encoding UTF8
$placeholder = '{{RAW_CONTENT}}'
$placeholderIndex = $content.IndexOf($placeholder, [System.StringComparison]::Ordinal)

if ($placeholderIndex -lt 0) {
    Write-Error "RAW_CONTENT placeholder not found. Manually check whether Raw Content is already filled."
    exit 1
}

$updatedContent = $content.Substring(0, $placeholderIndex) +
    $clipboardText +
    $content.Substring($placeholderIndex + $placeholder.Length)

Set-Content -LiteralPath $targetPath -Value $updatedContent -Encoding UTF8 -NoNewline

$resolvedPath = (Resolve-Path -LiteralPath $targetPath).Path
$importedCharacters = $clipboardText.Length

Write-Output "Updated source path: $resolvedPath"
Write-Output "Clipboard characters imported: $importedCharacters"
Write-Output ""
Write-Output "Next steps:"
Write-Output "1. Review the raw source file."
Write-Output "2. Commit the raw source."
Write-Output "3. Run ingest-prompt.ps1 for the same source path."
