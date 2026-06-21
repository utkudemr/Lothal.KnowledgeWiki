<#
.SYNOPSIS
  Lightweight deterministic wiki validator for Lothal.KnowledgeWiki Phase 2 MVP.

DESCRIPTION
  Checks repository for required root files, validates relative markdown links
  inside `wiki/**/*.md`, ensures wiki pages have Source References and that
  referenced raw paths exist. Reports placeholder tokens as warnings.

USAGE
  Run from repository root or from any location. The script resolves the repo
  root relative to the script file location.

IMPLEMENTATION NOTES
  - Uses only built-in PowerShell features.
  - Does not modify any files.
#>

# Determine repository root (parent of the scripts directory)
if ($PSScriptRoot) {
    $RepoRoot = Resolve-Path (Join-Path $PSScriptRoot '..')
} else {
    $RepoRoot = Resolve-Path (Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Definition) '..')
}
$RepoRoot = $RepoRoot.ProviderPath

Write-Host "Repo root: $RepoRoot"

# Counters and collections
$FilesScanned = 0
$LinksChecked = 0
$Errors = [System.Collections.Generic.List[string]]::new()
$Warnings = [System.Collections.Generic.List[string]]::new()

# 1) Required root files
$required = @(
    'AGENTS.md',
    'wiki/index.md',
    'wiki/log.md'
)
foreach ($r in $required) {
    $path = Join-Path $RepoRoot $r
    if (-not (Test-Path $path)) {
        $Errors.Add("Missing required file: $r")
    }
}

# Helper: add error/warning with file context
function Add-Error($msg) { $Errors.Add($msg) }
function Add-Warning($msg) { $Warnings.Add($msg) }

# Tokens to warn about (placeholders/templates)
$placeholders = @(
    'INGEST_OUTPUT',
    '{{SOURCE_PATH}}',
    'raw/path/to/source.md',
    'wiki/concepts/example.md',
    '../concepts/example.md'
)

# TODO/TBD are reported case-insensitively

# Files to skip Source References requirement (workspace-relative)
$sourceExclusions = @(
    'wiki/index.md',
    'wiki/log.md',
    'wiki/reading-guide.md',
    'wiki/projects/phase-1-status-report.md'
)

# Find all markdown files under wiki/
$wikiDir = Join-Path $RepoRoot 'wiki'
if (-not (Test-Path $wikiDir)) {
    Add-Error("Missing wiki directory: wiki/")
} else {
    $mdFiles = Get-ChildItem -Path $wikiDir -Recurse -Include *.md -File
    foreach ($file in $mdFiles) {
        $FilesScanned++
        $content = Get-Content -Raw -LiteralPath $file.FullName -ErrorAction SilentlyContinue
        if ($null -eq $content) { continue }

        # 2) Validate markdown relative links
        $linkPattern = '\[[^\]]*\]\(([^)]+)\)'
        $matches = [regex]::Matches($content, $linkPattern)
        foreach ($m in $matches) {
            $rawLink = $m.Groups[1].Value.Trim()

            # Ignore empty links
            if ([string]::IsNullOrWhiteSpace($rawLink)) { continue }

            # Ignore external links and mailto and anchor-only links
            if ($rawLink -match '^(https?:)//') { continue }
            if ($rawLink -match '^mailto:') { continue }
            if ($rawLink -match '^#') { continue }

            # Strip any anchor fragment
            $linkNoFrag = $rawLink.Split('#')[0]
            $linkNoFrag = $linkNoFrag.Trim()
            if ($linkNoFrag -eq '') { continue }

            # Only validate local relative .md links
            $ext = [System.IO.Path]::GetExtension($linkNoFrag)
            if ($ext -ne '.md') { continue }

            # Skip absolute paths starting with / or drive letters (treat only relative links)
            if ($linkNoFrag -match '^[\\/]' -or $linkNoFrag -match '^[a-zA-Z]:\\') { continue }

            $LinksChecked++

            # Resolve relative to the markdown file's directory
            $baseDir = Split-Path -Parent $file.FullName
            $candidate = [System.IO.Path]::GetFullPath((Join-Path $baseDir $linkNoFrag))
            if (-not (Test-Path $candidate)) {
                Add-Error("Broken link in $($file.FullName): '$rawLink' -> resolved: $candidate")
            }
        }

        # 3) Ensure Source References section exists (unless excluded)
        $relpath = $file.FullName.Substring($RepoRoot.Length).TrimStart('\','/') -replace '\\','/'
        if (-not ($sourceExclusions -contains $relpath)) {
            if (-not ($content -match '(?m)^##\s*Source References' -or $content -match '(?m)^##\s*Kaynak Referansları')) {
                Add-Error("Missing Source References in $relpath")
            }
        }

        # 4) Check raw path references exist
        $rawPattern = 'raw/[\w\-./]+'
        $rawMatches = [regex]::Matches($content, $rawPattern)
        foreach ($rm in $rawMatches) {
            $rawPath = $rm.Value.Trim()
            $candidateRaw = Join-Path $RepoRoot $rawPath
            if (-not (Test-Path $candidateRaw)) {
                Add-Error("Referenced raw path not found in ${relpath}: $rawPath")
            }
        }

        # 5) Placeholder/template leftovers -> warnings
        foreach ($token in $placeholders) {
            if ($content -like "*$token*") {
                Add-Warning("Placeholder token '$token' found in $relpath")
            }
        }
        # TODO/TBD case-insensitive
        if ($content -match '(?i)\bTODO\b') { Add-Warning("TODO found in $relpath") }
        if ($content -match '(?i)\bTBD\b') { Add-Warning("TBD found in $relpath") }
    }
}

# Summary output
Write-Host "`nSummary:`nFiles scanned: $FilesScanned`nLinks checked: $LinksChecked`nErrors: $($Errors.Count)`nWarnings: $($Warnings.Count)`n"

if ($Errors.Count -gt 0) {
    Write-Host "Errors:" -ForegroundColor Red
    foreach ($e in $Errors) { Write-Host "- $e" }
} else {
    Write-Host "No errors found." -ForegroundColor Green
}

if ($Warnings.Count -gt 0) {
    Write-Host "`nWarnings:" -ForegroundColor Yellow
    foreach ($w in $Warnings) { Write-Host "- $w" }
}

# Exit code: 0 when no errors, 1 when there are errors
if ($Errors.Count -gt 0) { exit 1 } else { exit 0 }
