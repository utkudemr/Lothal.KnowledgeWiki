# Usage example:
#   .\scripts\start-ingest.ps1 article "Article Title" "https://example.com/article"

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

$typeFolders = @{
    article   = 'raw/articles'
    tweet     = 'raw/tweets'
    repo      = 'raw/repos'
    video     = 'raw/videos'
    job       = 'raw/job-postings'
    interview = 'raw/interview-questions'
    chat      = 'raw/chat-summaries'
}

function Show-Usage {
    Write-Output 'Usage:'
    Write-Output '.\scripts\start-ingest.ps1 article "Article Title" "https://example.com/article"'
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

if (-not (Test-Path -LiteralPath $newSourceScript -PathType Leaf)) {
    Write-Error "Required helper script not found: $newSourceScript"
    exit 1
}

if (-not (Test-Path -LiteralPath $ingestPromptScript -PathType Leaf)) {
    Write-Error "Required helper script not found: $ingestPromptScript"
    exit 1
}

$capturedAt = Get-Date -Format 'yyyy-MM-dd'
$slug = ConvertTo-KebabSlug -Value $Title
$relativeFolder = $typeFolders[$Type]
$expectedDirectory = Join-Path $root $relativeFolder
$expectedFileName = "$capturedAt-$slug.md"
$expectedPath = Join-Path $expectedDirectory $expectedFileName

if (Test-Path -LiteralPath $expectedPath -PathType Leaf) {
    $relativeSourcePath = ConvertTo-RepositoryRelativePath -Path $expectedPath

    Write-Output ''
    Write-Output "Raw source already exists: $relativeSourcePath"
    Write-Output ''

    try {
        & $ingestPromptScript $relativeSourcePath
    }
    catch {
        Write-Error "ingest-prompt.ps1 failed: $($_.Exception.Message)"
        exit 1
    }

    Write-Output ''
    Write-Output 'Next steps:'
    Write-Output '1. Open the existing raw source file.'
    Write-Output '2. Ensure Context Notes and Raw Content are complete.'
    Write-Output '3. Commit the raw source if needed.'
    Write-Output '4. Paste the copied ingest prompt into the IDE agent/chat.'
    exit 0
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
    Write-Error "Could not determine the created raw source path from new-source.ps1 output."
    exit 1
}

$relativeSourcePath = ConvertTo-RepositoryRelativePath -Path $createdPath

Write-Output ''
Write-Output 'Created raw source file:'
Write-Output $relativeSourcePath
Write-Output ''

try {
    & $ingestPromptScript $relativeSourcePath
}
catch {
    Write-Error "ingest-prompt.ps1 failed: $($_.Exception.Message)"
    exit 1
}

Write-Output ''
Write-Output 'Next steps:'
Write-Output '1. Open the created raw source file.'
Write-Output '2. Fill Context Notes.'
Write-Output '3. Fill Raw Content.'
Write-Output '4. Commit the raw source.'
Write-Output '5. Paste the copied ingest prompt into the IDE agent/chat.'
Write-Output '6. After ingest, run review-prompt.ps1.'
Write-Output '7. Run validate-wiki.ps1 before committing wiki changes.'
