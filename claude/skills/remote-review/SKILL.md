---
allowed-tools: Bash(gh issue view:*), Bash(gh search:*), Bash(gh issue list:*), Bash(gh pr comment:*), Bash(gh pr diff:*), Bash(gh pr view:*), Bash(gh pr list:*)
description: Code review a pull request
disable-model-invocation: false
---

Code review the given pull request. Make a todo list first.

## Steps

1. **Eligibility check** (Haiku agent): Skip if the PR is closed, trivially correct, automated, or already reviewed by you.
2. **Gather context** (Haiku agent): List paths of relevant CLAUDE.md files (root + directories touched by the PR).
3. **Summarize** (Sonnet agent): View the PR and return a summary of the change.
4. **Review** (5 parallel Sonnet agents): Each returns a list of issues with reasons.
   - CLAUDE.md compliance (note: not all CLAUDE.md instructions apply to review)
   - Shallow bug scan (changes only, no extra context; focus on large bugs)
   - Git blame/history for bugs visible in historical context
   - Comments from previous PRs that touched these files
   - Code comment compliance in modified files
5. **Score** (parallel Haiku per issue): Confidence 0-100 using this rubric:
   - **0**: False positive or pre-existing issue
   - **25**: Might be real but unverified; stylistic issue not in CLAUDE.md
   - **50**: Verified but minor/nitpick
   - **75**: Verified, likely hit in practice, directly impacts functionality or explicitly mentioned in CLAUDE.md
   - **100**: Confirmed real, frequent, evidence directly supports it
6. **Filter**: Drop issues below 80. If none remain, stop.
7. **Re-check eligibility** (Haiku): Confirm PR is still open and eligible.
8. **Post comment** via `gh pr comment`.

## False positives (filter these out)

- Pre-existing issues or issues on unmodified lines
- Things a linter/typechecker/compiler would catch (CI handles these)
- Pedantic nitpicks a senior engineer wouldn't flag
- General quality concerns (coverage, docs, security) unless CLAUDE.md requires them
- CLAUDE.md violations explicitly silenced in code (e.g. lint ignore comments)
- Intentional functionality changes related to the broader PR

## Comment format

Use `gh` for all GitHub interaction. Cite and link every issue.

Code links must use full SHA with line range context:
`https://github.com/OWNER/REPO/blob/FULL_SHA/path/file.ext#L4-L7`

Do not use bash interpolation in links -- resolve the full SHA first.

```markdown
### Code review

Found N issues:

1. Brief description (CLAUDE.md says "...")

<link with full SHA + line range>

1. Brief description (bug due to <file and snippet>)

<link with full SHA + line range>

Generated with [Claude Code](https://claude.ai/code)
```

If no issues pass the filter, post:

```markdown
### Code review

No issues found.

Generated with [Claude Code](https://claude.ai/code)
```
