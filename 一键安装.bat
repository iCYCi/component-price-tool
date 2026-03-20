@echo off
chcp 65001 >nul
title 元器件比价工具 - Tauri版安装向导
color 0B

echo ================================================================
echo     元器件比价工具 v2.0 - Tauri桌面版安装向导
echo ================================================================
echo.
echo 本工具将自动安装所有必需的开发环境并构建应用程序
echo.
pause

echo.
echo [步骤 1/5] 检查系统环境...
echo.

REM 检查Node.js
node --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到Node.js
    echo.
    echo 正在下载Node.js 20 LTS...
    powershell -Command "Invoke-WebRequest -Uri 'https://nodejs.org/dist/v20.11.0/node-v20.11.0-x64.msi' -OutFile '%TEMP%\node-installer.msi'"
    
    echo 正在安装Node.js...
    start /wait msiexec /i "%TEMP%\node-installer.msi" /passive /norestart
    
    echo ✅ Node.js安装完成
) else (
    echo ✅ Node.js已安装
    node --version
)

REM 检查Rust
rustc --version >nul 2>&1
if errorlevel 1 (
    echo ❌ 未检测到Rust
    echo.
    echo 正在下载Rust安装程序...
    powershell -Command "Invoke-WebRequest -Uri 'https://static.rust-lang.org/rustup/dist/x86_64-pc-windows-msvc/rustup-init.exe' -OutFile '%TEMP%\rustup-init.exe'"
    
    echo 正在安装Rust...
    echo 请在安装界面选择默认选项
    start /wait %TEMP%\rustup-init.exe
    
    echo ✅ Rust安装完成
) else (
    echo ✅ Rust已安装
    rustc --version
)

REM 检查Visual Studio Build Tools
where cl.exe >nul 2>&1
if errorlevel 1 (
    echo ⚠️  未检测到Visual Studio Build Tools
    echo.
    echo 正在下载Visual Studio Build Tools...
    powershell -Command "Invoke-WebRequest -Uri 'https://aka.ms/vs/17/release/vs_BuildTools.exe' -OutFile '%TEMP%\vs-build-tools.exe'"
    
    echo 正在安装...
    echo 请在安装界面选择"Desktop development with C++"
    start /wait %TEMP%\vs-build-tools.exe
) else (
    echo ✅ Visual Studio Build Tools已安装
)

echo.
echo [步骤 2/5] 安装项目依赖...
echo.

REM 安装前端依赖
call npm install
if errorlevel 1 (
    echo ⚠️  npm安装失败，尝试使用国内镜像...
    call npm install --registry=https://registry.npmmirror.com
)

echo ✅ 依赖安装完成

echo.
echo [步骤 3/5] 构建应用程序...
echo.
echo 这可能需要几分钟，请耐心等待...
echo.

REM 构建Tauri应用
call npm run tauri:build

if errorlevel 1 (
    echo ❌ 构建失败，请检查错误信息
    pause
    exit /b 1
)

echo ✅ 构建成功！

echo.
echo [步骤 4/5] 创建桌面快捷方式...
echo.

REM 创建桌面快捷方式
set DESKTOP=%USERPROFILE%\Desktop
set EXE_PATH=%CD%\src-tauri\target\release\元器件比价工具.exe

if exist "%EXE_PATH%" (
    echo Set oWS = WScript.CreateObject("WScript.Shell") > "%TEMP%\CreateShortcut.vbs"
    echo sLinkFile = "%DESKTOP%\元器件比价工具.lnk" >> "%TEMP%\CreateShortcut.vbs"
    echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%TEMP%\CreateShortcut.vbs"
    echo oLink.TargetPath = "%EXE_PATH%" >> "%TEMP%\CreateShortcut.vbs"
    echo oLink.WorkingDirectory = "%CD%" >> "%TEMP%\CreateShortcut.vbs"
    echo oLink.Description = "元器件比价工具 v2.0 - Tauri版" >> "%TEMP%\CreateShortcut.vbs"
    echo oLink.Save >> "%TEMP%\CreateShortcut.vbs"
    
    cscript //nologo "%TEMP%\CreateShortcut.vbs" >nul 2>&1
    
    echo ✅ 桌面快捷方式创建成功
) else (
    echo ⚠️  未找到生成的exe文件
)

echo.
echo [步骤 5/5] 安装完成！
echo.
echo ================================================================
echo     安装成功！
echo ================================================================
echo.
echo 📁 应用位置：
if exist "%EXE_PATH%" (
    echo    %EXE_PATH%
    echo.
    for %%F in ("%EXE_PATH%") do echo 📊 文件大小：%%~zF 字节
)
echo.
echo 🚀 启动方式：
echo    1. 双击桌面"元器件比价工具"图标
echo    2. 或运行 src-tauri\target\release\元器件比价工具.exe
echo.
echo ✨ 特点：
echo    - 超小体积（约3-5MB）
echo    - 无需安装运行时
echo    - 跨平台支持
echo    - 本地数据存储
echo.

pause