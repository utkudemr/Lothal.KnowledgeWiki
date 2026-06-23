# Usage example:
#   .\scripts\start-ingest.ps1 article "Article Title" "https://example.com/article"

param(
    [Parameter(Mandatory = $true, Position = 0)]
    [ValidateSet('article', 'tweet', 'repo', 'video', 'job', 'interview', 'chat')]
    [string]$Type,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Title,

    [Parameter(Mandatory = $true, Position = 2)]
    [string]$Url
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$newSourceScript = Join-Path $PSScriptRoot 'new-source.ps1'
$ingestPromptScript = Join-Path $PSScriptRoot 'ingest-prompt.ps1'

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

if (-not (Test-Path -LiteralPath $newSourceScript -PathType Leaf)) {
    Write-Error "Required helper script not found: $newSourceScript"
    exit 1
}

if (-not (Test-Path -LiteralPath $ingestPromptScript -PathType Leaf)) {
    Write-Error "Required helper script not found: $ingestPromptScript"
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
