#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Version management script for the Foundations-Training repository
.DESCRIPTION
    This script helps manage semantic versioning, git tags, and changelog updates
    Note: This script should be run from the repository root directory
.PARAMETER Action
    The action to perform: bump, tag, or info
.PARAMETER Type
    For bump action: major, minor, or patch
.EXAMPLE
    .\scripts\version.ps1 -Action info
    .\scripts\version.ps1 -Action bump -Type patch
    .\scripts\version.ps1 -Action tag
#>

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("info", "bump", "tag")]
    [string]$Action,
    
    [Parameter(Mandatory = $false)]
    [ValidateSet("major", "minor", "patch")]
    [string]$Type
)

# Get the repository root directory (parent of scripts directory)
$repoRoot = Split-Path -Parent $PSScriptRoot
$versionFile = Join-Path $repoRoot "VERSION"
$changelogFile = Join-Path $repoRoot "CHANGELOG.md"

# Ensure we're working from the repository root for git commands
Push-Location $repoRoot

function Get-CurrentVersion {
    if (Test-Path $versionFile) {
        return Get-Content $versionFile -Raw | ForEach-Object { $_.Trim() }
    }
    return "0.0.0"
}

function Set-Version {
    param([string]$version)
    $version | Set-Content $versionFile -NoNewline
}

function Invoke-VersionBump {
    param([string]$bumpType)
    
    $currentVersion = Get-CurrentVersion
    $versionParts = $currentVersion.Split('.')
    
    $major = [int]$versionParts[0]
    $minor = [int]$versionParts[1]
    $patch = [int]$versionParts[2]
    
    switch ($bumpType) {
        "major" { 
            $major++
            $minor = 0
            $patch = 0
        }
        "minor" { 
            $minor++
            $patch = 0
        }
        "patch" { 
            $patch++
        }
    }
    
    $newVersion = "$major.$minor.$patch"
    Set-Version $newVersion
    
    Write-Host "Version bumped from $currentVersion to $newVersion" -ForegroundColor Green
    return $newVersion
}

function Invoke-CreateTag {
    $version = Get-CurrentVersion
    $tagName = "v$version"
    
    # Check if tag already exists
    $existingTag = git tag -l $tagName
    if ($existingTag) {
        Write-Host "Tag $tagName already exists!" -ForegroundColor Yellow
        return
    }
    
    # Create annotated tag
    $tagMessage = "Release version $version"
    git tag -a $tagName -m $tagMessage
    
    Write-Host "Created tag: $tagName" -ForegroundColor Green
    Write-Host "To push the tag, run: git push origin $tagName" -ForegroundColor Cyan
}

function Show-VersionInfo {
    $currentVersion = Get-CurrentVersion
    $latestTag = git describe --tags --abbrev=0 2>$null
    $commitsSinceTag = ""
    
    if ($latestTag) {
        $commitCount = git rev-list "$latestTag..HEAD" --count 2>$null
        if ($commitCount -gt 0) {
            $commitsSinceTag = " ($commitCount commits since $latestTag)"
        }
    }
    
    Write-Host "Current Version: $currentVersion$commitsSinceTag" -ForegroundColor Cyan
    Write-Host "Latest Git Tag: $($latestTag ?? 'None')" -ForegroundColor Yellow
    
    # Show recent commits
    Write-Host "`nRecent commits:" -ForegroundColor Magenta
    git log --oneline -5
}

# Main execution
switch ($Action) {
    "info" {
        Show-VersionInfo
    }
    "bump" {
        if (-not $Type) {
            Write-Host "Error: Type parameter is required for bump action" -ForegroundColor Red
            Write-Host "Usage: .\scripts\version.ps1 -Action bump -Type [major|minor|patch]"
            exit 1
        }
        Invoke-VersionBump $Type
    }
    "tag" {
        Invoke-CreateTag
    }
}

# Restore original location
Pop-Location