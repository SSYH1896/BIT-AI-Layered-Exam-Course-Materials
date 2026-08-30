# 北理工分层AI考试课程试卷资源 - GitHub发布脚本
# 用法：右键 → 使用PowerShell运行

$ErrorActionPreference = "Stop"
$projectDir = "C:\Users\25982\Desktop\BITai考试"
$repoName = "北理工分层AI考试课程试卷资源"

Set-Location $projectDir
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  北理工分层AI考试课程试卷资源" -ForegroundColor Cyan
Write-Host "  GitHub 发布助手" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Step 1: 显示当前目录
Write-Host "[步骤1] 当前工作目录：" -ForegroundColor Yellow
Write-Host "  $projectDir"
Write-Host ""

# Step 2: 检查Git是否安装
Write-Host "[步骤2] 检查Git环境..." -ForegroundColor Yellow
try {
    $gitVersion = git --version
    Write-Host "  ✓ $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "  ✗ 未检测到Git，请先安装Git: https://git-scm.com/" -ForegroundColor Red
    pause
    exit 1
}
Write-Host ""

# Step 3: 检查GitHub CLI
Write-Host "[步骤3] 检查GitHub CLI..." -ForegroundColor Yellow
$hasGh = $false
try {
    $ghVersion = gh --version 2>$null
    if ($ghVersion) {
        Write-Host "  ✓ $ghVersion" -ForegroundColor Green
        $hasGh = $true
    }
} catch {
    Write-Host "  ! 未安装GitHub CLI（可选）：https://cli.github.com/" -ForegroundColor Yellow
}
Write-Host ""

# Step 4: 配置Git用户信息
Write-Host "[步骤4] 配置Git用户信息..." -ForegroundColor Yellow
$email = Read-Host "  请输入你的GitHub邮箱"
$username = Read-Host "  请输入你的GitHub用户名"
git config user.email "$email"
git config user.name "$username"
Write-Host "  ✓ Git配置完成" -ForegroundColor Green
Write-Host ""

# Step 5: 初始化仓库
Write-Host "[步骤5] 初始化Git仓库..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "  ! 仓库已存在，跳过初始化" -ForegroundColor Yellow
} else {
    git init
    Write-Host "  ✓ 仓库初始化完成" -ForegroundColor Green
}
Write-Host ""

# Step 6: 添加文件
Write-Host "[步骤6] 添加文件..." -ForegroundColor Yellow
git add README.md .gitignore "考试重点.md" "5套模拟卷及答案.md" intro.txt examinfo.txt outline.txt
git status
Write-Host "  ✓ 文件已暂存" -ForegroundColor Green
Write-Host ""

# Step 7: 提交
Write-Host "[步骤7] 创建提交..." -ForegroundColor Yellow
git commit -m "Initial commit: BITai考试复习资料"
Write-Host "  ✓ 提交完成" -ForegroundColor Green
Write-Host ""

# Step 8: 切换到main分支
Write-Host "[步骤8] 切换到main分支..." -ForegroundColor Yellow
git branch -M main
Write-Host "  ✓ 已切换到main分支" -ForegroundColor Green
Write-Host ""

# Step 9: 选择创建方式
Write-Host "[步骤9] 选择仓库创建方式..." -ForegroundColor Yellow
Write-Host "  1) 使用GitHub CLI自动创建并推送"
Write-Host "  2) 手动在GitHub创建仓库后推送"
$choice = Read-Host "  请输入选择 (1 或 2)"

if ($choice -eq "1" -and $hasGh) {
    Write-Host ""
    Write-Host "[使用GitHub CLI创建仓库]" -ForegroundColor Yellow
    $repoName = Read-Host "  请输入仓库名称（默认为 BITai-exam）"
    if ([string]::IsNullOrWhiteSpace($repoName)) { $repoName = "BITai-exam" }

    # 检查登录状态
    Write-Host "  检查GitHub登录状态..." -ForegroundColor Yellow
    $authStatus = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  ! 需要先登录GitHub" -ForegroundColor Yellow
        gh auth login
    }

    Write-Host "  正在创建仓库..." -ForegroundColor Yellow
    gh repo create $repoName --public --source=. --push --description "北京理工大学研究生人工智能公共基础课分层考试复习资料、模拟试卷及参考答案"
    Write-Host "  ✓ 仓库创建并推送完成！" -ForegroundColor Green
    Write-Host ""
    Write-Host "  仓库地址：https://github.com/$username/$repoName" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "[手动创建仓库模式]" -ForegroundColor Yellow
    Write-Host "  请按以下步骤操作：" -ForegroundColor Cyan
    Write-Host "  1. 浏览器打开 https://github.com/new"
    Write-Host "  2. 填写仓库名（建议：BITai-exam）"
    Write-Host "  3. 选择 Public（公开）"
    Write-Host "  4. 不要勾选 Add README / .gitignore"
    Write-Host "  5. 点击 Create repository"
    Write-Host ""
    $repoUrl = Read-Host "  创建完成后，请粘贴仓库URL（例如 https://github.com/$username/BITai-exam.git）"

    if ([string]::IsNullOrWhiteSpace($repoUrl)) {
        $repoUrl = "https://github.com/$username/BITai-exam.git"
    }

    Write-Host "  添加远程仓库..." -ForegroundColor Yellow
    git remote remove origin 2>$null
    git remote add origin $repoUrl
    Write-Host "  推送到GitHub..." -ForegroundColor Yellow
    git push -u origin main

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ 推送成功！" -ForegroundColor Green
    } else {
        Write-Host "  ! 推送可能失败，请检查网络或认证设置" -ForegroundColor Yellow
        Write-Host "  提示：如果是第一次推送，可能需要使用 Personal Access Token 认证" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "  全部完成！感谢开源分享 :)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""
pause
