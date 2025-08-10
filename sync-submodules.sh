#!/bin/bash
# 子模块同步脚本 - 确保所有子模块都是最新的并且已推送

echo "=== 子模块同步脚本 ==="

# 1. 同步子模块配置
echo "步骤 1: 同步子模块配置..."
git submodule sync --recursive

# 2. 初始化和更新子模块
echo "步骤 2: 初始化和更新子模块..."
git submodule update --init --recursive

# 3. 检查并推送 public 子模块的未推送提交
echo "步骤 3: 检查 public 子模块..."
cd public
if [ -n "$(git log origin/main..HEAD --oneline)" ]; then
    echo "发现 public 子模块有未推送的提交，正在推送..."
    git push origin main
else
    echo "public 子模块已是最新状态"
fi
cd ..

# 4. 检查并推送 themes/DoIt 子模块的未推送提交
echo "步骤 4: 检查 themes/DoIt 子模块..."
cd themes/DoIt
if [ -n "$(git log origin/main..HEAD --oneline)" ]; then
    echo "发现 themes/DoIt 子模块有未推送的提交，正在推送..."
    git push origin main
else
    echo "themes/DoIt 子模块已是最新状态"
fi
cd ../..

# 5. 更新主仓库中的子模块引用
echo "步骤 5: 更新主仓库中的子模块引用..."
git add .gitmodules
if [ -n "$(git diff --cached --name-only)" ]; then
    git commit -m "更新子模块配置和引用"
    echo "已提交子模块配置更新"
else
    echo "无需提交更改"
fi

echo "=== 子模块同步完成 ==="
