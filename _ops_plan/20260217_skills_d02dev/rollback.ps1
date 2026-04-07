# Rollback Script for Skills Library Reorganization
# Operation ID: 20260217_skills_d02dev
# WARNING: This script reverses the folder reorganization. Use only if needed.
# Run from: D:\02_Development\Skills

param(
    [switch]$DryRun = $false,
    [switch]$Force = $false
)

$ErrorActionPreference = "Stop"
$base = "D:\02_Development\Skills"

if (-not $Force) {
    Write-Host "WARNING: This will reverse the folder reorganization." -ForegroundColor Yellow
    Write-Host "Run with -Force to execute, or -DryRun to preview." -ForegroundColor Yellow
    exit 1
}

function Move-SafeItem($src, $dst) {
    if ($DryRun) {
        Write-Host "[DRY-RUN] Would move: $src -> $dst" -ForegroundColor Cyan
    } else {
        if (Test-Path $src) {
            $parent = Split-Path $dst -Parent
            if (-not (Test-Path $parent)) { New-Item -ItemType Directory -Path $parent -Force | Out-Null }
            Move-Item -Path $src -Destination $dst -Force
            Write-Host "[MOVED] $src -> $dst" -ForegroundColor Green
        } else {
            Write-Host "[SKIP] Source not found: $src" -ForegroundColor Yellow
        }
    }
}

Write-Host "=== Rollback: Platform Directories ===" -ForegroundColor Magenta

# Reverse platform moves (kebab-case back to PascalCase)
$platformMoves = @(
    @("$base\platforms\claude\claude-skills", "$base\Claude\ClaudeSkills"),
    @("$base\platforms\claude\claude-skills-cli", "$base\Claude\ClaudeSkills-CLI"),
    @("$base\platforms\claude\claude-skills-desktop", "$base\Claude\ClaudeSkills-Desktop"),
    @("$base\platforms\claude\claude-skills-web", "$base\Claude\ClaudeSkills-Web"),
    @("$base\platforms\codex\codex-skills", "$base\Codex\CodexSkills"),
    @("$base\platforms\codex\codex-skills-cli", "$base\Codex\CodexSkills-CLI"),
    @("$base\platforms\gemini\gemini-skills", "$base\Gemini\GeminiSkills"),
    @("$base\platforms\gemini\gemini-skills-cli", "$base\Gemini\GeminiSkills-CLI"),
    @("$base\platforms\gemini\gemini-skills-studio", "$base\Gemini\GeminiSkills-Studio"),
    @("$base\platforms\gemini\gemini-skills-agents", "$base\Gemini\GeminiSkills-Agents"),
    @("$base\platforms\github-copilot\copilot-skills", "$base\GithubCopilot\CopilotSkills"),
    @("$base\platforms\github-copilot\copilot-skills-cli", "$base\GithubCopilot\CopilotSkills-CLI"),
    @("$base\platforms\github-copilot\copilot-skills-frontier", "$base\GithubCopilot\CopilotSkills-Frontier")
)

foreach ($move in $platformMoves) {
    Move-SafeItem $move[0] $move[1]
}

Write-Host "`n=== Rollback: Supporting Directories ===" -ForegroundColor Magenta
Move-SafeItem "$base\adapters\universal" "$base\UniversalAdapters"
Move-SafeItem "$base\agents\github-repo" "$base\GitHubRepoAgents"

Write-Host "`n=== Rollback: Scripts ===" -ForegroundColor Magenta
$scriptMoves = @(
    @("$base\scripts\populate-all.py", "$base\populate_all.py"),
    @("$base\scripts\sync-skills.py", "$base\sync-skills.py"),
    @("$base\scripts\convert-to-gems.py", "$base\convert_to_gems.py"),
    @("$base\scripts\convert-to-codex-responses.py", "$base\convert_to_codex_responses.py"),
    @("$base\scripts\convert-to-copilot.js", "$base\convert-to-copilot.js"),
    @("$base\scripts\convert-to-copilot.py", "$base\convert_to_copilot.py"),
    @("$base\scripts\convert-to-cli-skills.py", "$base\convert_to_cli_skills.py"),
    @("$base\scripts\fix-skills-unified.py", "$base\fix_skills_unified.py"),
    @("$base\scripts\fix-claude-desktop.py", "$base\fix_claude_desktop.py"),
    @("$base\scripts\verify-claude-desktop-structure.py", "$base\verify_claude_desktop_structure.py"),
    @("$base\scripts\compare-claude-desktop-structures.py", "$base\compare_claude_desktop_structures.py"),
    @("$base\scripts\regenerate-gemini-studio.js", "$base\regenerate_gemini_studio.js"),
    @("$base\scripts\run-convert.bat", "$base\run_convert.bat")
)

foreach ($move in $scriptMoves) {
    Move-SafeItem $move[0] $move[1]
}

Write-Host "`n=== Rollback: Docs ===" -ForegroundColor Magenta
$docMoves = @(
    @("$base\docs\planning\index.md", "$base\INDEX.md"),
    @("$base\docs\planning\master-index.md", "$base\MASTER_INDEX.md"),
    @("$base\docs\planning\master-enhancement-plan.md", "$base\MASTER_ENHANCEMENT_PLAN.md"),
    @("$base\docs\planning\phase-a1-runbook.md", "$base\PHASE_A1_RUNBOOK.md"),
    @("$base\docs\planning\phase-a2-runbook.md", "$base\PHASE_A2_RUNBOOK.md"),
    @("$base\docs\planning\phase-a3-runbook.md", "$base\PHASE_A3_RUNBOOK.md"),
    @("$base\docs\planning\deployment-checklist.md", "$base\DEPLOYMENT_CHECKLIST.md"),
    @("$base\docs\planning\populate-all-changes.md", "$base\POPULATE_ALL_CHANGES.md"),
    @("$base\docs\planning\int-inc-skills-plugin-lae-plan.md", "$base\INT_Inc_Skills_Plugin_LAE_Plan.md"),
    @("$base\docs\planning\tier1-skill-definitions.md", "$base\TIER1_SKILL_DEFINITIONS.md"),
    @("$base\docs\claude-desktop-fix.md", "$base\CLAUDE_DESKTOP_FIX.md"),
    @("$base\docs\readme-claude-desktop-fix.md", "$base\README_CLAUDE_DESKTOP_FIX.md")
)

foreach ($move in $docMoves) {
    Move-SafeItem $move[0] $move[1]
}

Write-Host "`n=== Rollback: Data Files ===" -ForegroundColor Magenta
$dataMoves = @(
    @("$base\data\concept-descriptions.json", "$base\concept-descriptions.json"),
    @("$base\data\enhancement-status.json", "$base\ENHANCEMENT_STATUS.json"),
    @("$base\data\tier-1-skills-candidates.csv", "$base\tier-1-skills-candidates.csv"),
    @("$base\data\tier-1-enhancement-template.md", "$base\tier-1-enhancement-template.md")
)

foreach ($move in $dataMoves) {
    Move-SafeItem $move[0] $move[1]
}

Write-Host "`n=== Cleanup empty directories ===" -ForegroundColor Magenta
$emptyDirs = @("$base\platforms", "$base\scripts", "$base\docs", "$base\data", "$base\adapters", "$base\agents")
foreach ($dir in $emptyDirs) {
    if ($DryRun) {
        Write-Host "[DRY-RUN] Would remove empty dir: $dir" -ForegroundColor Cyan
    } else {
        if ((Test-Path $dir) -and ((Get-ChildItem $dir -Recurse -File).Count -eq 0)) {
            Remove-Item $dir -Recurse -Force
            Write-Host "[REMOVED] Empty dir: $dir" -ForegroundColor Green
        }
    }
}

Write-Host "`nNOTE: After rollback, you must also revert code changes in:" -ForegroundColor Yellow
Write-Host "  - lib/config.py (path constants)" -ForegroundColor Yellow
Write-Host "  - All scripts (sys.path and import paths)" -ForegroundColor Yellow
Write-Host "  Use 'git checkout -- lib/ scripts/' to revert code changes." -ForegroundColor Yellow

Write-Host "`nRollback complete!" -ForegroundColor Green
