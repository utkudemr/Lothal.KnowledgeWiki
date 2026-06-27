# Usage example:
#   .\scripts\capture-and-prepare-ingest.ps1 article "Article Title" "https://example.com/article"

param(
    [Parameter(Position = 0)]
    [string]$Type,

    [Parameter(Position = 1)]
    [string]$Title,

    [Parameter(Position = 2)]
    [string]$Url
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$newSourceScript = Join-Path $PSScriptRoot 'new-source.ps1'
$ingestPromptScript = Join-Path $PSScriptRoot 'ingest-prompt.ps1'
$validateWikiScript = Join-Path $PSScriptRoot 'validate-wiki.ps1'

$typeFolders = @{
    article   = 'raw/articles'
    tweet     = 'raw/tweets'
    repo      = 'raw/repos'
    video     = 'raw/videos'
    job       = 'raw/job-postings'
    interview = 'raw/interview-questions'
    chat      = 'raw/chat-summaries'
}

$defaultContextNotes = @'
This source was captured to understand and summarize the topic for the knowledge wiki.

Focus areas:
- Main idea
- Practical engineering implications
- Agent workflow relevance
- .NET/backend relevance
- Interview relevance
- Personal project connections
'@

function Show-Usage {
    Write-Output 'Usage:'
    Write-Output '.\scripts\capture-and-prepare-ingest.ps1 article "Article Title" "https://example.com/article"'
}

function ConvertTo-KebabSlug {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    $normalized = $Value.ToLowerInvariant()
    $normalized = $normalized -replace '[^a-z0-9]+', '-'
    $normalized = $normalized.Trim('-')
    $normalized = $normalized -replace '-{2,}', '-'

    if ([string]::IsNullOrWhiteSpace($normalized)) {
        Write-Error 'Title must contain at least one ASCII letter or number for slug generation.'
        exit 1
    }

    return $normalized
}

function ConvertTo-RepositoryRelativePath {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Path
    )

    $resolvedPath = (Resolve-Path -LiteralPath $Path).Path
    $rootWithSeparator = $root.TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar

    if (-not $resolvedPath.StartsWith($rootWithSeparator, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Error "Created source path is outside repository root: $resolvedPath"
        exit 1
    }

    return $resolvedPath.Substring($rootWithSeparator.Length).Replace([System.IO.Path]::DirectorySeparatorChar, '/')
}

function Replace-FirstOccurrence {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$Placeholder,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Replacement
    )

    $placeholderIndex = $Content.IndexOf($Placeholder, [System.StringComparison]::Ordinal)

    if ($placeholderIndex -lt 0) {
        Write-Error "Placeholder not found in the created raw source: $Placeholder"
        exit 1
    }

    return $Content.Substring(0, $placeholderIndex) +
        $Replacement +
        $Content.Substring($placeholderIndex + $Placeholder.Length)
}

if ([string]::IsNullOrWhiteSpace($Type) -or [string]::IsNullOrWhiteSpace($Title) -or [string]::IsNullOrWhiteSpace($Url)) {
    Write-Output 'Error: Missing required arguments: Type, Title and Url are required.'
    Show-Usage
    exit 1
}

if (-not $typeFolders.ContainsKey($Type)) {
    Write-Output "Error: Invalid source type: $Type"
    Write-Output "Valid types: $($typeFolders.Keys -join ', ')"
    Show-Usage
    exit 1
}

foreach ($requiredScript in @($newSourceScript, $ingestPromptScript, $validateWikiScript)) {
    if (-not (Test-Path -LiteralPath $requiredScript -PathType Leaf)) {
        Write-Error "Required helper script not found: $requiredScript"
        exit 1
    }
}

$clipboardText = Get-Clipboard -Raw

if ([string]::IsNullOrWhiteSpace($clipboardText)) {
    Write-Output 'Clipboard is empty. Copy the article markdown/text first.'
    exit 1
}

$capturedAt = Get-Date -Format 'yyyy-MM-dd'
$slug = ConvertTo-KebabSlug -Value $Title
$relativeFolder = $typeFolders[$Type]
$expectedPath = Join-Path (Join-Path $root $relativeFolder) "$capturedAt-$slug.md"

if (Test-Path -LiteralPath $expectedPath) {
    $displayPath = $expectedPath

    if (Test-Path -LiteralPath $expectedPath -PathType Leaf) {
        $displayPath = ConvertTo-RepositoryRelativePath -Path $expectedPath
    }

    Write-Output "Raw source already exists: $displayPath"
    Write-Output 'Use start-ingest.ps1 to prepare an ingest prompt for the existing source, or import-clipboard-source.ps1 if its Raw Content placeholder still needs clipboard content.'
    exit 1
}

try {
    $newSourceOutput = & $newSourceScript $Type $Title $Url
}
catch {
    Write-Error "new-source.ps1 failed: $($_.Exception.Message)"
    exit 1
}

$createdPath = $newSourceOutput |
    Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
    Select-Object -Last 1

if ([string]::IsNullOrWhiteSpace($createdPath) -or -not (Test-Path -LiteralPath $createdPath -PathType Leaf)) {
    Write-Error 'Could not determine the created raw source path from new-source.ps1 output.'
    exit 1
}

$relativeSourcePath = ConvertTo-RepositoryRelativePath -Path $createdPath
$sourceContent = Get-Content -LiteralPath $createdPath -Raw -Encoding UTF8
$sourceContent = Replace-FirstOccurrence -Content $sourceContent -Placeholder '{{RAW_CONTENT}}' -Replacement $clipboardText
$sourceContent = Replace-FirstOccurrence -Content $sourceContent -Placeholder '{{CONTEXT_NOTES}}' -Replacement $defaultContextNotes
Set-Content -LiteralPath $createdPath -Value $sourceContent -Encoding UTF8 -NoNewline

try {
    & $ingestPromptScript $relativeSourcePath
}
catch {
    Write-Error "ingest-prompt.ps1 failed: $($_.Exception.Message)"
    exit 1
}

Write-Output ''
Write-Output 'Validation output:'
$powerShellExecutable = (Get-Process -Id $PID).Path
& $powerShellExecutable -NoProfile -ExecutionPolicy Bypass -File $validateWikiScript
$validationExitCode = $LASTEXITCODE

if ($validationExitCode -ne 0) {
    Write-Output ''
    Write-Output "Validation failed with exit code $validationExitCode. Fix the reported errors before committing."
    exit $validationExitCode
}

Write-Output ''
Write-Output 'Capture and prepare ingest completed.'
Write-Output "Created raw source path: $relativeSourcePath"
Write-Output "Clipboard character count imported: $($clipboardText.Length)"
Write-Output 'Validation result: Passed'
Write-Output 'Ingest prompt copied to clipboard: Yes'
Write-Output ''
Write-Output 'Next steps:'
Write-Output '1. Review the raw source file.'
Write-Output '2. Optionally improve Context Notes.'
Write-Output '3. Commit the raw source:'
Write-Output "   git add $relativeSourcePath"
Write-Output "   git commit -m `"add $slug source`""
Write-Output '   git push'
Write-Output '4. Paste the copied ingest prompt into the IDE agent/chat.'
