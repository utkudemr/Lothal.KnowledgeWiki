# Usage example:
#   .\scripts\capture-and-prepare-ingest.ps1 article "Article Title" "https://example.com/article"
#   .\scripts\capture-and-prepare-ingest.ps1 tweet "Example Source" "https://example.com/source" -MemoryPath "C:\Path\To\KnowledgeMemory"

param(
    [Parameter(Position = 0)]
    [string]$Type,

    [Parameter(Position = 1)]
    [string]$Title,

    [Parameter(Position = 2)]
    [string]$Url,

    [Parameter()]
    [string]$MemoryPath
)

$ErrorActionPreference = 'Stop'

$root = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
$newSourceScript = Join-Path $PSScriptRoot 'new-source.ps1'
$ingestPromptScript = Join-Path $PSScriptRoot 'ingest-prompt.ps1'
$validateWikiScript = Join-Path $PSScriptRoot 'validate-wiki.ps1'
$sourceTemplatePath = Join-Path $root '.agent/templates/source.md'

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
    Write-Output '.\scripts\capture-and-prepare-ingest.ps1 tweet "Example Source" "https://example.com/source" -MemoryPath "C:\Path\To\KnowledgeMemory"'
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

function Replace-SectionPlaceholderBlock {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Content,

        [Parameter(Mandatory = $true)]
        [string]$SectionHeading,

        [Parameter(Mandatory = $true)]
        [string]$Placeholder,

        [Parameter(Mandatory = $true)]
        [AllowEmptyString()]
        [string]$Replacement
    )

    $pattern = '(?ms)(^' + [regex]::Escape($SectionHeading) + '[ \t]*\r?\n).*?' + [regex]::Escape($Placeholder)
    $match = [regex]::Match($Content, $pattern)

    if (-not $match.Success) {
        Write-Error "Section placeholder block not found in the created raw source: $SectionHeading / $Placeholder"
        exit 1
    }

    $headingWithLineEnding = $match.Groups[1].Value
    $lineEnding = if ($headingWithLineEnding.EndsWith("`r`n")) { "`r`n" } else { "`n" }

    return $Content.Substring(0, $match.Index) +
        $headingWithLineEnding +
        $lineEnding +
        $Replacement +
        $Content.Substring($match.Index + $match.Length)
}

function New-ExternalMemoryIngestPrompt {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RepositoryRoot,

        [Parameter(Mandatory = $true)]
        [string]$SourcePath,

        [Parameter(Mandatory = $true)]
        [string]$SourceUrl,

        [Parameter(Mandatory = $true)]
        [string]$VaultReference
    )

    return @"
You are ingesting a private source into Lothal.KnowledgeWiki.

Public KnowledgeWiki repository:
$RepositoryRoot

External raw source file:
$SourcePath

Source URL:
$SourceUrl

Private raw source logical reference:
$VaultReference

Instructions:
- Read AGENTS.md from the public KnowledgeWiki repository first: $RepositoryRoot\AGENTS.md
- Read the raw source file from the external path: $SourcePath
- Do not modify the external raw source file.
- Create or update wiki output in the current public KnowledgeWiki repository unless later instructed otherwise.
- Write generated wiki content in Turkish unless the source requires English.
- Avoid duplicate pages, use relative markdown links and follow the page templates in AGENTS.md.
- In every created or updated wiki page, preserve both source references under Source References:
  - Source URL: $SourceUrl
  - Private raw source: $VaultReference
- Update wiki/index.md when pages are created or meaningfully updated.
- Append an entry to wiki/log.md.
- Do not copy private raw content into the public repository beyond the public-safe synthesis needed for wiki output.
- Run .\scripts\validate-wiki.ps1 after creating or updating wiki pages.
- Do not recommend a final commit until review and validation pass with Errors: 0.

Analyze the source for its main idea, technical claims, practical examples, .NET/backend relevance, distributed systems or microservices relevance, agent workflow relevance, interview value and personal project connections. Check existing wiki pages before deciding what to create or update.

Finish with a summary of created files, updated files, important decisions, recommended reading order, validation result or reminder, and open questions.
"@
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

if ($PSBoundParameters.ContainsKey('MemoryPath')) {
    if ([string]::IsNullOrWhiteSpace($MemoryPath) -or -not (Test-Path -LiteralPath $MemoryPath -PathType Container)) {
        Write-Output "Error: MemoryPath does not exist or is not a directory: $MemoryPath"
        exit 1
    }

    $resolvedMemoryPath = (Resolve-Path -LiteralPath $MemoryPath).Path
}

$requiredFiles = @($validateWikiScript, $sourceTemplatePath)

if (-not $PSBoundParameters.ContainsKey('MemoryPath')) {
    $requiredFiles += @($newSourceScript, $ingestPromptScript)
}

foreach ($requiredFile in $requiredFiles) {
    if (-not (Test-Path -LiteralPath $requiredFile -PathType Leaf)) {
        Write-Error "Required file not found: $requiredFile"
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
$typeFolder = Split-Path -Leaf $relativeFolder
$fileName = "$capturedAt-$slug.md"

if ($PSBoundParameters.ContainsKey('MemoryPath')) {
    $targetDirectory = Join-Path (Join-Path $resolvedMemoryPath 'raw') $typeFolder
}
else {
    $targetDirectory = Join-Path $root $relativeFolder
}

$expectedPath = Join-Path $targetDirectory $fileName

if (Test-Path -LiteralPath $expectedPath) {
    $displayPath = $expectedPath

    if (-not $PSBoundParameters.ContainsKey('MemoryPath') -and (Test-Path -LiteralPath $expectedPath -PathType Leaf)) {
        $displayPath = ConvertTo-RepositoryRelativePath -Path $expectedPath
    }

    Write-Output "Raw source already exists: $displayPath"
    if ($PSBoundParameters.ContainsKey('MemoryPath')) {
        Write-Output 'Choose a different title or review the existing private memory source.'
    }
    else {
        Write-Output 'Use start-ingest.ps1 to prepare an ingest prompt for the existing source, or import-clipboard-source.ps1 if its Raw Content placeholder still needs clipboard content.'
    }
    exit 1
}

if ($PSBoundParameters.ContainsKey('MemoryPath')) {
    New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null

    $sourceContent = Get-Content -LiteralPath $sourceTemplatePath -Raw -Encoding UTF8
    $sourceContent = $sourceContent.Replace('{{TITLE}}', $Title)
    $sourceContent = $sourceContent.Replace('{{SOURCE_URL}}', $Url)
    $sourceContent = $sourceContent.Replace('{{CAPTURED_AT}}', $capturedAt)
    $sourceContent = $sourceContent.Replace('{{SOURCE_TYPE}}', $Type)
    $createdPath = $expectedPath
}
else {
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

    $sourceContent = Get-Content -LiteralPath $createdPath -Raw -Encoding UTF8
}

$sourceContent = Replace-SectionPlaceholderBlock -Content $sourceContent -SectionHeading '## Context Notes' -Placeholder '{{CONTEXT_NOTES}}' -Replacement $defaultContextNotes
$sourceContent = Replace-SectionPlaceholderBlock -Content $sourceContent -SectionHeading '## Raw Content' -Placeholder '{{RAW_CONTENT}}' -Replacement $clipboardText
$sourceContent = $sourceContent -replace '(?m)^> Source type examples:.*\r?\n(?:\r?\n)?', ''
Set-Content -LiteralPath $createdPath -Value $sourceContent -Encoding UTF8 -NoNewline

if ($PSBoundParameters.ContainsKey('MemoryPath')) {
    $createdPath = (Resolve-Path -LiteralPath $createdPath).Path
    $vaultSourceReference = "vault://raw/$typeFolder/$fileName"
    $ingestPrompt = New-ExternalMemoryIngestPrompt -RepositoryRoot $root -SourcePath $createdPath -SourceUrl $Url -VaultReference $vaultSourceReference
    Set-Clipboard -Value $ingestPrompt
}
else {
    $relativeSourcePath = ConvertTo-RepositoryRelativePath -Path $createdPath

    try {
        & $ingestPromptScript $relativeSourcePath
    }
    catch {
        Write-Error "ingest-prompt.ps1 failed: $($_.Exception.Message)"
        exit 1
    }
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

if ($PSBoundParameters.ContainsKey('MemoryPath')) {
    Write-Output "Created memory source path: $createdPath"
    Write-Output "Logical vault source reference: $vaultSourceReference"
    Write-Output "Clipboard character count imported: $($clipboardText.Length)"
    Write-Output 'Ingest prompt copied to clipboard: Yes'
    Write-Output 'Validation result: Passed'
    Write-Output ''
    Write-Output 'Next steps:'
    Write-Output '1. Review the memory raw source file.'
    Write-Output '2. Paste the copied ingest prompt into the IDE agent/chat.'
    Write-Output '3. Review generated wiki output.'
    Write-Output '4. Validate.'
    Write-Output '5. Commit only public wiki/script changes to KnowledgeWiki.'
}
else {
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
}
