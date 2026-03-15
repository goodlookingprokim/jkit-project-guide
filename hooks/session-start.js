#!/usr/bin/env node
/**
 * jkit VibeCTO Agent Team Guide - SessionStart Hook (v1.1.0)
 * Claude Code plugin
 *
 * Initializes jkit session with team introduction,
 * detects bkit plugin for "One Family" integration,
 * and provides guided onboarding for beginner developers.
 */

const fs = require('fs');
const path = require('path');

// ============================================================
// Utility Functions
// ============================================================

function debugLog(context, message, data = {}) {
  if (process.env.JKIT_DEBUG === '1') {
    console.error(`[jkit:${context}] ${message}`, JSON.stringify(data));
  }
}

// ============================================================
// bkit Integration (One Family)
// ============================================================

let bkitCommon = null;
let bkitAvailable = false;

/**
 * Try to load bkit's common library for PDCA status sharing
 */
function tryLoadBkit() {
  // Allowed base directories for bkit loading
  const pluginRoot = path.resolve(__dirname, '..');
  const homeDir = process.env.HOME || process.env.USERPROFILE || '';
  const allowedBases = [
    pluginRoot,
    homeDir ? path.join(homeDir, '.claude', 'plugins') : null,
  ].filter(Boolean);

  const possiblePaths = [
    // Same repo (submodule)
    path.join(__dirname, '..', 'bkit-claude-code', 'lib', 'common.js'),
    // Plugin cache
    homeDir ? path.join(homeDir, '.claude', 'plugins', 'cache', 'bkit-claude-code', 'lib', 'common.js') : null,
  ].filter(Boolean);

  for (const p of possiblePaths) {
    try {
      // Validate resolved path is within allowed directories
      const resolved = path.resolve(p);
      const isAllowed = allowedBases.some(base => resolved.startsWith(path.resolve(base)));
      if (!isAllowed) {
        debugLog('bkit', 'Path outside allowed directories, skipping', { path: resolved });
        continue;
      }

      if (fs.existsSync(resolved)) {
        bkitCommon = require(resolved);
        bkitAvailable = true;
        debugLog('bkit', 'bkit common.js loaded', { path: resolved });
        return;
      }
    } catch (e) {
      debugLog('bkit', 'Failed to load bkit', { path: p, error: e.message });
    }
  }
}

tryLoadBkit();

/**
 * Detect jkit-specific project indicators
 */
function detectProject() {
  const cwd = process.cwd();
  const indicators = {
    hasPackageJson: fs.existsSync(path.join(cwd, 'package.json')),
    hasSrc: fs.existsSync(path.join(cwd, 'src')),
    hasCleanArch: fs.existsSync(path.join(cwd, 'src', 'core', 'domain')),
    hasTests: false,
    hasSupabase: fs.existsSync(path.join(cwd, 'supabase')),
  };

  // Check for test files
  try {
    const srcDir = path.join(cwd, 'src');
    if (fs.existsSync(srcDir)) {
      const excludeDirs = new Set(['node_modules', '.next', 'dist', 'build', 'coverage', '.git']);
      const findTests = (dir, depth = 0) => {
        if (depth > 10) return false;
        const entries = fs.readdirSync(dir, { withFileTypes: true });
        for (const entry of entries) {
          if (entry.isFile() && (entry.name.endsWith('.test.ts') || entry.name.endsWith('.spec.ts'))) {
            return true;
          }
          if (entry.isDirectory() && !excludeDirs.has(entry.name)) {
            if (findTests(path.join(dir, entry.name), depth + 1)) return true;
          }
        }
        return false;
      };
      indicators.hasTests = findTests(srcDir);
    }
  } catch (e) {
    // Ignore
  }

  return indicators;
}

/**
 * Get bkit PDCA status if available
 */
function getBkitPdcaStatus() {
  if (!bkitAvailable || !bkitCommon) return null;

  try {
    if (typeof bkitCommon.getPdcaStatusFull === 'function') {
      return bkitCommon.getPdcaStatusFull();
    }
  } catch (e) {
    debugLog('bkit', 'Failed to get PDCA status', { error: e.message });
  }
  return null;
}

// ============================================================
// Session Start Output
// ============================================================

const project = detectProject();
const pdcaStatus = getBkitPdcaStatus();

let additionalContext = `# jkit VibeCTO Agent Team Guide v1.1.0 - Session Startup\n\n`;

// Team introduction
additionalContext += `## Your Team\n`;
additionalContext += `- 🎯 **VibeCTO** (Lead) — Discovers ideas, plans architecture, orchestrates team\n`;
additionalContext += `- 🧪 **TDD Coach** — Writes tests first, ensures code quality (Red-Green-Refactor)\n`;
additionalContext += `- 🏗️ **Arch Mentor** — Designs Clean Architecture, verifies dependency rules\n`;
additionalContext += `- 🎨 **Frontend Buddy** — Builds UI with Next.js, Tailwind CSS, shadcn/ui\n`;
additionalContext += `- ☁️ **SaaS Guide** — Handles Supabase, payments, APIs, deployment\n\n`;

// Available commands
additionalContext += `## Available Commands\n`;
additionalContext += `| Command | Purpose |\n`;
additionalContext += `|---------|--------|\n`;
additionalContext += `| /jkit | Show team and commands |\n`;
additionalContext += `| /jkit-start | Discover project idea with VibeCTO |\n`;
additionalContext += `| /jkit-plan | Create actionable project plan |\n`;
additionalContext += `| /jkit-build | Build features with specialist agents |\n`;
additionalContext += `| /jkit-test | TDD workflow (Red-Green-Refactor) |\n`;
additionalContext += `| /jkit-review | Code review + architecture check |\n`;
additionalContext += `| /jkit-team | Activate Agent Team parallel mode |\n`;
additionalContext += `| /jkit-status | Check project progress |\n`;
additionalContext += `| /jkit-next | Get VibeCTO's next task recommendation |\n\n`;

// Project detection
if (project.hasPackageJson) {
  additionalContext += `## Project Detected\n`;
  additionalContext += `- Source code: ${project.hasSrc ? 'Yes' : 'No'}\n`;
  additionalContext += `- Clean Architecture: ${project.hasCleanArch ? 'Applied' : 'Not applied'}\n`;
  additionalContext += `- Tests: ${project.hasTests ? 'Found' : 'Not found'}\n`;
  additionalContext += `- Supabase: ${project.hasSupabase ? 'Configured' : 'Not configured'}\n\n`;
} else {
  additionalContext += `## No Project Detected\n`;
  additionalContext += `- Suggest /jkit-start to begin a new project\n\n`;
}

// bkit One Family integration
if (bkitAvailable) {
  additionalContext += `## jkit + bkit: One Family\n`;
  additionalContext += `- bkit detected. PDCA pipeline available for structured development.\n`;
  additionalContext += `- jkit provides beginner-friendly guided workflows with VibeCTO team\n`;
  additionalContext += `- bkit provides PDCA pipeline, gap analysis, and quality tools\n`;
  additionalContext += `- Both share Agent Teams infrastructure\n`;

  if (pdcaStatus && pdcaStatus.primaryFeature) {
    additionalContext += `- Active PDCA feature: ${pdcaStatus.primaryFeature} (phase: ${pdcaStatus.features?.[pdcaStatus.primaryFeature]?.phase || 'unknown'})\n`;
  }

  additionalContext += `- Use /pdca commands alongside /jkit commands for full workflow\n\n`;
} else {
  additionalContext += `## Standalone Mode\n`;
  additionalContext += `- jkit running independently (bkit not detected)\n`;
  additionalContext += `- For enhanced PDCA workflow, install bkit plugin alongside jkit\n\n`;
}

// Onboarding prompt
additionalContext += `## 🚨 MANDATORY: Session Start Action\n\n`;
additionalContext += `**AskUserQuestion tool** call required on user's first message.\n\n`;

const onboardingPrompt = JSON.stringify({
  questions: [{
    question: 'Jkit 팀과 함께 무엇을 하시겠어요?',
    header: '시작하기',
    options: [
      { label: '새 프로젝트 시작', description: 'VibeCTO와 대화하며 아이디어 발견 (/jkit-start)' },
      { label: '기존 프로젝트 이어서', description: '현재 프로젝트 상태 확인 (/jkit-status)' },
      { label: '팀 소개 보기', description: 'Jkit 팀과 커맨드 안내 (/jkit)' },
      { label: '자유롭게 시작', description: '가이드 없이 바로 작업' }
    ],
    multiSelect: false
  }]
});

additionalContext += `${onboardingPrompt}\n\n`;

additionalContext += `### Actions by selection:\n`;
additionalContext += `- **새 프로젝트 시작** → Run /jkit-start\n`;
additionalContext += `- **기존 프로젝트 이어서** → Run /jkit-status then /jkit-next\n`;
additionalContext += `- **팀 소개 보기** → Run /jkit\n`;
additionalContext += `- **자유롭게 시작** → General conversation mode\n\n`;

additionalContext += `💡 Important: AI Agent is not perfect. Always verify important decisions.\n`;

// Output JSON response
const response = {
  systemMessage: `jkit VibeCTO Agent Team Guide v1.1.0 activated`,
  hookSpecificOutput: {
    hookEventName: "SessionStart",
    onboardingType: project.hasPackageJson ? 'existing_project' : 'new_user',
    bkitIntegration: bkitAvailable,
    additionalContext: additionalContext
  }
};

console.log(JSON.stringify(response));
process.exit(0);
