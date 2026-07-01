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
        [string]$SourceTitle,

        [Parameter(Mandatory = $true)]
        [string]$SourceType,

        [Parameter(Mandatory = $true)]
        [string]$VaultReference,

        [Parameter(Mandatory = $true)]
        [string]$PrivateInsightPath,

        [Parameter(Mandatory = $true)]
        [string]$NotesRoot,

        [Parameter(Mandatory = $true)]
        [string]$ConceptsPath,

        [Parameter(Mandatory = $true)]
        [string]$SynthesesPath,

        [Parameter(Mandatory = $true)]
        [string]$InterviewPath,

        [Parameter(Mandatory = $true)]
        [string]$ReadingPathsPath,

        [Parameter(Mandatory = $true)]
        [string]$ProjectsPath,

        [Parameter(Mandatory = $true)]
        [string]$ReadingOrderPath,

        [Parameter(Mandatory = $true)]
        [string]$HomePath,

        [Parameter(Mandatory = $true)]
        [string]$ConceptIndexPath,

        [Parameter(Mandatory = $true)]
        [string]$SourceGraphPath,

        [Parameter(Mandatory = $true)]
        [string]$TopicMapsPath
    )

    # Build Turkish section names without depending on the script file's BOM/encoding.
    $ccedilla = [char]0x00E7
    $dotlessI = [char]0x0131
    $gbreve = [char]0x011F
    $scedilla = [char]0x015F
    $uuml = [char]0x00FC
    $privateInsightSections = @(
        "Benim i${ccedilla}in ana fikir"
        "Bildiklerimle ba${gbreve}lant${dotlessI}"
        "Pratik backend/.NET ${ccedilla}${dotlessI}kar${dotlessI}mlar${dotlessI}"
        "Mikroservis/distributed systems ba${gbreve}lant${dotlessI}s${dotlessI}"
        "M${uuml}lakat a${ccedilla}${dotlessI}s${dotlessI}ndan nas${dotlessI}l anlat${dotlessI}l${dotlessI}r"
        "Ki${scedilla}isel eksikler / sonraki okuma"
        "K${dotlessI}sa haf${dotlessI}za kart${dotlessI}"
    )
    $privateInsightSectionList = ($privateInsightSections | ForEach-Object { "  - $_" }) -join [Environment]::NewLine

    return @"
You are ingesting a private source into Lothal.KnowledgeWiki.

Public KnowledgeWiki repository:
$RepositoryRoot

External raw source file:
$SourcePath

Source URL:
$SourceUrl

Source title:
$SourceTitle

Source type:
$SourceType

Private raw source logical reference:
$VaultReference

External generated-note targets:
- Notes root: $NotesRoot
- Concepts: $ConceptsPath
- Syntheses: $SynthesesPath
- Interview: $InterviewPath
- Reading paths: $ReadingPathsPath
- Projects: $ProjectsPath

Reading order note target:
$ReadingOrderPath

External memory home target:
$HomePath

External memory map targets:
- Concept index: $ConceptIndexPath
- Source graph: $SourceGraphPath
- Topic maps: $TopicMapsPath

Private insight note target:
$PrivateInsightPath

Instructions:
- Read AGENTS.md from the public KnowledgeWiki repository first: $RepositoryRoot\AGENTS.md
- Read the raw source file from the external path: $SourcePath
- Do not modify the external raw source file.
- MemoryPath mode overrides repo-local ingest rules in AGENTS.md: do not create or update generated knowledge pages under the public repository's wiki/ folder.
- Create or update generated knowledge notes only under the external targets listed above.
- Before writing, inspect existing notes under $ConceptsPath, $SynthesesPath, $InterviewPath and $ReadingPathsPath. Also inspect $ConceptIndexPath and $SourceGraphPath when they exist.
- Identify 3-7 related existing notes when possible. Use only concrete semantic relationships and classify each as builds-on, contrasts-with, complements, prerequisite, follow-up, similar-pattern, applied-example or broader-context. Do not invent links to meet a quota.
- Every generated note must include a "Hafıza Bağlantıları" section with "İlgili Notlar", "Bu kaynak neyi tamamlıyor?", "Bu kaynak hangi gerilimi veya farkı gösteriyor?" and "Sonraki bağlanabilecek konular" subsections. Format related notes as `[[note-name]] — relationship type: short reason`.
- Keep generated notes reusable where possible, but treat them as private/synced memory outputs rather than public repository outputs.
- Use relative markdown links between external notes and use lowercase kebab-case file names.
- Preserve the raw source in generated notes only through this logical Source References value: $VaultReference
- Do not expose physical local paths inside generated notes. Physical paths are allowed only in private operational notes under the supplied MemoryPath, when necessary.
- Keep personal reflections, company/career connections, private reading history and "how this applies to me" material in insights/, not notes/.
- Do not modify wiki/index.md or wiki/log.md for this private source ingest.
- Do not copy source-specific generated notes or private raw content into the public repository.
- Do not commit any MemoryPath file to the public repository.
- Public repository changes should normally be limited to source-independent script, prompt, validator or documentation improvements; this ingest should not require such a change.
- Write generated notes and the private insight note in Turkish unless the source requires English.
- Also create or update a private insight note at: $PrivateInsightPath
- Write the private insight note in Turkish by default.
- Use these sections in the private insight note:
$privateInsightSectionList
- Keep personal insights, company/career connections, private reading history and "how this applies to me" reflections in the private insight note only. Reusable technical project knowledge may live under notes/projects/ without personal reflection.
- Do not copy raw source content verbatim into the private insight note; summarize and reflect instead.
- Do not copy the private insight note or its private details into the public repository.
- After generating notes and the private insight, create or update the reading order note at: $ReadingOrderPath
- The reading order note must include: title, source type, the logical raw reference $VaultReference, created note list, recommended reading order, why this order, and optional follow-up reading or questions.
- The reading order note must also include "Bağlantılı Okuma" with "Önce okunabilecekler", "Beraber okunabilecekler" and "Sonra okunabilecekler" subsections.
- Link to generated notes from the reading order note with Obsidian wiki links when possible. Keep link targets portable and do not include physical local paths.
- If $HomePath exists, append or update one entry under a "Recent Ingests" section. If it does not exist, create it with a "Recent Ingests" section.
- The home entry must link to the reading order note and must not duplicate the reading order contents.
- Treat the reading order note and home.md as private MemoryPath outputs. Never write their source-specific content to the public repository.
- Create or update $ConceptIndexPath as a lightweight concept index; keep topic headings, note links and short keyword summaries rather than copying note content.
- Create or update $SourceGraphPath. Under the source entry $VaultReference, record generated notes and concrete related-note edges with relationship type and a short reason.
- When a coherent topic cluster clearly benefits from navigation, create or update a lowercase kebab-case topic map under $TopicMapsPath. Do not create a topic map merely to satisfy the workflow.
- Run .\scripts\validate-wiki.ps1 only if the public repository was intentionally changed for an engine/framework improvement.
- Never recommend committing external MemoryPath outputs to the public repository.

Analyze the source for its main idea, technical claims, practical examples, .NET/backend relevance, distributed systems or microservices relevance, agent workflow relevance and interview value. Inspect the existing external notes and maps before deciding what to create or update. Analyze personal, company and career connections only for the private insight note.

Finish with a summary that lists external notes created or updated, the private insight note target, reading order target, home.md update, any public engine/framework changes (normally none), important decisions and open questions. Do not reproduce private insight content in the summary.
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
    $privateInsightDirectory = Join-Path (Join-Path $resolvedMemoryPath 'insights') $typeFolder
    $notesRoot = Join-Path $resolvedMemoryPath 'notes'
    $conceptsDirectory = Join-Path $notesRoot 'concepts'
    $synthesesDirectory = Join-Path $notesRoot 'syntheses'
    $interviewDirectory = Join-Path $notesRoot 'interview'
    $projectsDirectory = Join-Path $notesRoot 'projects'
    $readingPathsDirectory = Join-Path $notesRoot 'reading-paths'
    $runsRoot = Join-Path $resolvedMemoryPath 'runs'
    $ingestsDirectory = Join-Path $runsRoot 'ingests'
    $ingestRunDirectory = Join-Path $ingestsDirectory "$capturedAt-$slug"
    $reviewResultsDirectory = Join-Path (Join-Path $resolvedMemoryPath 'runs') 'review-results'
    $readingOrdersDirectory = Join-Path (Join-Path $resolvedMemoryPath 'runs') 'reading-orders'
    $mapsDirectory = Join-Path $resolvedMemoryPath 'maps'
    $topicMapsDirectory = Join-Path $mapsDirectory 'topics'
    $conceptIndexPath = Join-Path $mapsDirectory 'concept-index.md'
    $sourceGraphPath = Join-Path $mapsDirectory 'source-graph.md'
    $inboxDirectory = Join-Path $resolvedMemoryPath 'inbox'
    $homeTargetPath = Join-Path $resolvedMemoryPath 'home.md'
    $privateInsightFileName = "$capturedAt-$slug-insights.md"
    $privateInsightTargetPath = Join-Path $privateInsightDirectory $privateInsightFileName
    $readingOrderFileName = "$capturedAt-$slug-reading-order.md"
    $readingOrderTargetPath = Join-Path $readingOrdersDirectory $readingOrderFileName
    $persistedIngestPromptPath = Join-Path $ingestRunDirectory 'ingest-prompt.md'
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
    @(
        $targetDirectory,
        $conceptsDirectory,
        $synthesesDirectory,
        $interviewDirectory,
        $projectsDirectory,
        $readingPathsDirectory,
        $privateInsightDirectory,
        $ingestRunDirectory,
        $reviewResultsDirectory,
        $readingOrdersDirectory,
        $mapsDirectory,
        $topicMapsDirectory,
        $inboxDirectory
    ) | ForEach-Object { New-Item -ItemType Directory -Path $_ -Force | Out-Null }

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
    $privateInsightTargetPath = [System.IO.Path]::GetFullPath($privateInsightTargetPath)
    $readingOrderTargetPath = [System.IO.Path]::GetFullPath($readingOrderTargetPath)
    $homeTargetPath = [System.IO.Path]::GetFullPath($homeTargetPath)
    $conceptIndexPath = [System.IO.Path]::GetFullPath($conceptIndexPath)
    $sourceGraphPath = [System.IO.Path]::GetFullPath($sourceGraphPath)
    $topicMapsDirectory = [System.IO.Path]::GetFullPath($topicMapsDirectory)
    $ingestRunDirectory = [System.IO.Path]::GetFullPath($ingestRunDirectory)
    $persistedIngestPromptPath = [System.IO.Path]::GetFullPath($persistedIngestPromptPath)
    $ingestPrompt = New-ExternalMemoryIngestPrompt -RepositoryRoot $root -SourcePath $createdPath -SourceUrl $Url -SourceTitle $Title -SourceType $Type -VaultReference $vaultSourceReference -PrivateInsightPath $privateInsightTargetPath -NotesRoot $notesRoot -ConceptsPath $conceptsDirectory -SynthesesPath $synthesesDirectory -InterviewPath $interviewDirectory -ReadingPathsPath $readingPathsDirectory -ProjectsPath $projectsDirectory -ReadingOrderPath $readingOrderTargetPath -HomePath $homeTargetPath -ConceptIndexPath $conceptIndexPath -SourceGraphPath $sourceGraphPath -TopicMapsPath $topicMapsDirectory
    Set-Content -LiteralPath $persistedIngestPromptPath -Value $ingestPrompt -Encoding UTF8 -NoNewline
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
    Write-Output "Created raw source path: $createdPath"
    Write-Output "Generated notes root path: $notesRoot"
    Write-Output "Private insight note target path: $privateInsightTargetPath"
    Write-Output "Reading order note target path: $readingOrderTargetPath"
    Write-Output "Concept index path: $conceptIndexPath"
    Write-Output "Source graph path: $sourceGraphPath"
    Write-Output "Run folder path: $ingestRunDirectory"
    Write-Output "Persisted ingest prompt path: $persistedIngestPromptPath"
    Write-Output "Logical vault reference: $vaultSourceReference"
    Write-Output "Clipboard character count imported: $($clipboardText.Length)"
    Write-Output 'Ingest prompt copied to clipboard: Yes'
    Write-Output 'Validation result: Passed'
    Write-Output ''
    Write-Output 'Next steps:'
    Write-Output '1. Review the memory raw source file.'
    Write-Output '2. Paste the copied ingest prompt into the IDE agent/chat.'
    Write-Output '3. Review the generated external notes, private insight, reading order and home entry.'
    Write-Output '4. Confirm that no source-specific output was written to the public repository wiki/ folder.'
    Write-Output '5. Do not commit MemoryPath files to KnowledgeWiki.'
    Write-Output '6. Validate KnowledgeWiki only if engine/framework files were intentionally changed.'
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
