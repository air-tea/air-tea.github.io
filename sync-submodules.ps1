# 子模块同步脚本 - PowerShell 版本
# 确保所有子模块都是最新的并且已推送

Write-Host "=== 子模块同步脚本 ===" -ForegroundColor Green

# 1. 同步子模块配置
Write-Host "步骤 1: 同步子模块配置..." -ForegroundColor Yellow
git submodule sync --recursive

# 2. 初始化和更新子模块
Write-Host "步骤 2: 初始化和更新子模块..." -ForegroundColor Yellow
git submodule update --init --recursive

# 3. 检查并推送 public 子模块的未推送提交
Write-Host "步骤 3: 检查 public 子模块..." -ForegroundColor Yellow
Set-Location public
$unpushedCommits = git log origin/main..HEAD --oneline
if ($unpushedCommits) {
    Write-Host "发现 public 子模块有未推送的提交，正在推送..." -ForegroundColor Cyan
    git push origin main
} else {
    Write-Host "public 子模块已是最新状态" -ForegroundColor Green
}
Set-Location ..

# 4. 检查并推送 themes/DoIt 子模块的未推送提交
Write-Host "步骤 4: 检查 themes/DoIt 子模块..." -ForegroundColor Yellow
Set-Location themes/DoIt
$unpushedCommits = git log origin/main..HEAD --oneline
if ($unpushedCommits) {
    Write-Host "发现 themes/DoIt 子模块有未推送的提交，正在推送..." -ForegroundColor Cyan
    git push origin main
} else {
    Write-Host "themes/DoIt 子模块已是最新状态" -ForegroundColor Green
}
Set-Location ../..

# 5. 更新主仓库中的子模块引用
Write-Host "步骤 5: 更新主仓库中的子模块引用..." -ForegroundColor Yellow
git add .gitmodules
$stagedFiles = git diff --cached --name-only
if ($stagedFiles) {
    git commit -m "更新子模块配置和引用"
    Write-Host "已提交子模块配置更新" -ForegroundColor Green
} else {
    Write-Host "无需提交更改" -ForegroundColor Green
}

Write-Host "=== 子模块同步完成 ===" -ForegroundColor Green
