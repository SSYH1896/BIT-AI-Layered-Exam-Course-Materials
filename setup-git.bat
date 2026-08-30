@echo off
cd /d "C:\Users\25982\Desktop\BITai考试"
echo === Current Directory ===
cd
echo === List Files ===
dir /b
echo === Git Init ===
git init
echo === Git Config ===
git config user.email "student@bit.edu.cn"
git config user.name "BIT Student"
echo === Git Add ===
git add README.md .gitignore "考试重点.md" "5套模拟卷及答案.md" intro.txt examinfo.txt outline.txt
echo === Git Status ===
git status
echo === Done ===
