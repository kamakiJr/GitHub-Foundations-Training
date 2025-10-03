# Scripts Directory

This directory contains utility scripts for repository management and development workflows.

## Available Scripts

### `version.ps1` - Version Management
A PowerShell script for managing semantic versioning, git tags, and changelog updates.

#### Prerequisites
- PowerShell 5.1 or later
- Git installed and configured
- Repository with VERSION and CHANGELOG.md files

#### Usage

```powershell
# Show current version information
.\scripts\version.ps1 -Action info

# Bump version numbers
.\scripts\version.ps1 -Action bump -Type patch    # Bug fixes (1.0.0 → 1.0.1)
.\scripts\version.ps1 -Action bump -Type minor    # New features (1.0.0 → 1.1.0)
.\scripts\version.ps1 -Action bump -Type major    # Breaking changes (1.0.0 → 2.0.0)

# Create git tags
.\scripts\version.ps1 -Action tag
```

#### Examples

```powershell
# Check current version and git status
PS> .\scripts\version.ps1 -Action info
Current Version: 1.0.0
Latest Git Tag: v1.0.0
Recent commits:
abc1234 Add version tracking system
def5678 Add CC0 license

# Bump patch version for a bug fix
PS> .\scripts\version.ps1 -Action bump -Type patch
Version bumped from 1.0.0 to 1.0.1

# Create a git tag for the new version
PS> .\scripts\version.ps1 -Action tag
Created tag: v1.0.1
To push the tag, run: git push origin v1.0.1
```

## Script Development Guidelines

When adding new scripts to this directory:

1. **Use clear, descriptive names** (e.g., `deploy.ps1`, `test-runner.ps1`)
2. **Include parameter validation** and help documentation
3. **Add error handling** for common failure scenarios
4. **Document usage** in this README
5. **Use consistent coding style** with existing scripts
6. **Include examples** of common use cases

## Directory Structure

```text
scripts/
├── README.md           # This file - documentation for all scripts
├── version.ps1         # Version management and git tagging
└── (future scripts)    # Additional utility scripts as needed
```

## Best Practices

- **Run from repository root**: Always execute scripts from the main repository directory
- **Check prerequisites**: Ensure required tools are installed before running scripts
- **Test changes**: Verify script behavior in a safe environment first
- **Follow semantic versioning**: Use appropriate version bump types for changes
- **Update changelog**: Keep CHANGELOG.md current with all changes