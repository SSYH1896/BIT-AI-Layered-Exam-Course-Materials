@echo off
chcp 65001 >nul
set REPO_NAME=北理工分层AI考试课程试卷资源
echo =========================================
echo   北理工分层AI考试课程试卷资源
echo   GitHub 发布助手
echo =========================================
echo.

cd /d "C:\Users\25982\Desktop\BITai考试"

echo [步骤1] 检查Git环境...
git --version >nul 2>&1
if errorlevel 1 (
    echo   X 未检测到Git，请先安装Git: https://git-scm.com/
    pause
    exit /b 1
)
echo   √ Git已安装
echo.

echo [步骤2] 检查GitHub CLI...
where gh >nul 2>&1
if errorlevel 1 (
    echo   ! 未安装GitHub CLI（可选）
) else (
    echo   √ GitHub CLI已安装
)
echo.

echo [步骤3] 配置Git用户信息
set /p email=   请输入GitHub邮箱:
set /p username=   请输入GitHub用户名:
git config user.email "%email%"
git config user.name "%username%"
echo   √ 配置完成
echo.

echo [步骤4] 初始化Git仓库
if exist .git (
    echo   ! 仓库已存在，跳过
) else (
    git init
    echo   √ 初始化完成
)
echo.

echo [步骤5] 添加文件
git add README.md .gitignore "考试重点.md" "5套模拟卷及答案.md" intro.txt examinfo.txt outline.txt
echo   √ 文件已暂存
git status
echo.

echo [步骤6] 创建提交
git commit -m "Initial commit: BITai考试复习资料"
echo   √ 提交完成
echo.

echo [步骤7] 切换到main分支
git branch -M main
echo.

echo [步骤8] 推送仓库
echo   请选择:
echo   1) 使用GitHub CLI自动创建并推送（推荐）
echo   2) 手动在GitHub创建后推送
set /p choice=   请选择 (1 或 2):

if "%choice%"=="1" (
    where gh >nul 2>&1
    if errorlevel 1 (
        echo   X 请先安装GitHub CLI: https://cli.github.com/
        pause
        exit /b 1
    )
    set /p reponame=   请输入仓库名称(默认 BITai-exam):
    if "%reponame%"=="" set reponame=BITai-exam
    gh repo create "%REPO_NAME%" --public --source=. --push --description "北京理工大学研究生人工智能公共基础课分层考试复习资料、模拟试卷及参考答案"
    echo   √ 完成！
    echo   仓库地址: https://github.com/%username%/%reponame%
) else (
    echo.
    echo   请按以下步骤操作:
    echo   1. 浏览器打开 https://github.com/new
    echo   2. 填写仓库名（建议 BITai-exam）
    echo   3. 选择 Public
    echo   4. 不要勾选 README/.gitignore
    echo   5. 点击 Create repository
    echo.
    set /p reponame=   请输入仓库名称(默认 BITai-exam):
    if "%reponame%"=="" set reponame=BITai-exam
    set /p repourl=   请粘贴仓库URL(默认 https://github.com/%username%/%reponame%.git):
    if "%repourl%"=="" set repourl=https://github.com/%username%/%reponame%.git
    git remote remove origin >nul 2>&1
    git remote add origin "%repourl%"
    echo   推送中...
    git push -u origin main
    if errorlevel 1 (
        echo   ! 推送失败，请检查认证设置
        echo   提示：可能需要使用 Personal Access Token
    ) else (
        echo   √ 推送成功！
    )
)

echo.
echo =========================================
echo   全部完成！感谢开源分享 :)
echo =========================================
pause
