# sped-master-skills 一鍵安裝腳本 (PowerShell)
# 支援安裝至全域 (~/.gemini/config/skills) 或 指定工作區 (.agent/skills)

param (
    [switch]$Global = $true,
    [string]$TargetWorkspace = ""
)

$SourceDir = Join-Path $PSScriptRoot "..\skills"
$Skills = Get-ChildItem -Path $SourceDir -Directory

if ($TargetWorkspace -ne "") {
    $DestBase = Join-Path $TargetWorkspace ".agent\skills"
    Write-Host "📦 準備安裝 Skills 至目標工作區: $DestBase" -ForegroundColor Cyan
} elseif ($Global) {
    $DestBase = Join-Path $env:USERPROFILE ".gemini\config\skills"
    Write-Host "🌐 準備安裝 Skills 至全域 Antigravity 設定: $DestBase" -ForegroundColor Cyan
}

if (-not (Test-Path $DestBase)) {
    New-Item -ItemType Directory -Path $DestBase -Force | Out-Null
}

foreach ($skill in $Skills) {
    $dest = Join-Path $DestBase $skill.Name
    Copy-Item -Path $skill.FullName -Destination $dest -Recurse -Force
    Write-Host "  ✅ 已同步 Skill: $($skill.Name)" -ForegroundColor Green
}

Write-Host "`n🎉 全部 Skill 安裝/同步完成！" -ForegroundColor Yellow