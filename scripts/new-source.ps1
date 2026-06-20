# Usage examples:
#   .\scripts\new-source.ps1 article "Why isn't everything async?" "https://example.com/async"
#   .\scripts\new-source.ps1 repo "Microsoft Aspire - AGENTS.md" "https://github.com/microsoft/aspire/blob/main/AGENTS.md"

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
$templatePath = Join-Path $root '.agent/templates/source.md'

if (-not (Test-Path -LiteralPath $templatePath -PathType Leaf)) {
    Write-Error "Source template not found: $templatePath"
    exit 1
}

$typeFolders = @{
    article   = 'raw/articles'
    tweet     = 'raw/tweets'
    repo      = 'raw/repos'
    video     = 'raw/videos'
    job       = 'raw/job-postings'
    interview = 'raw/interview-questions'
    chat      = 'raw/chat-summaries'
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

$capturedAt = Get-Date -Format 'yyyy-MM-dd'
$slug = ConvertTo-KebabSlug -Value $Title
$relativeFolder = $typeFolders[$Type]
$targetDirectory = Join-Path $root $relativeFolder
$fileName = "$capturedAt-$slug.md"
$targetPath = Join-Path $targetDirectory $fileName

if (Test-Path -LiteralPath $targetPath) {
    Write-Error "Raw source file already exists: $targetPath"
    exit 1
}

New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

$content = Get-Content -LiteralPath $templatePath -Raw
$content = $content.Replace('{{TITLE}}', $Title)
$content = $content.Replace('{{SOURCE_URL}}', $Url)
$content = $content.Replace('{{CAPTURED_AT}}', $capturedAt)
$content = $content.Replace('{{SOURCE_TYPE}}', $Type)
$content = $content.Replace('{{CONTEXT_NOTES}}', 'Bu kaynak neden eklendiğini burada açıklayın.')
$content = $content.Replace('{{RAW_CONTENT}}', 'Kaynak içeriğini buraya yapıştırın.')

Set-Content -LiteralPath $targetPath -Value $content -Encoding UTF8 -NoNewline

$createdPath = Resolve-Path -LiteralPath $targetPath
Write-Output $createdPath.Path
