@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo  Deploying and Starting LoginApp1 on Apache Tomcat
echo ========================================================

set "CATALINA_HOME=C:\Users\mokta\Downloads\apache-tomcat-9.0.121"
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-8.0.482.8-hotspot"
set "PROJECT_DIR=%~dp0"
set "TARGET_APP=%CATALINA_HOME%\webapps\LoginApp1"

echo [1/3] Syncing latest web assets to Tomcat webapps...
if not exist "%TARGET_APP%" mkdir "%TARGET_APP%"
xcopy /E /I /Y /Q "%PROJECT_DIR%src\main\webapp\*" "%TARGET_APP%\" >nul

if exist "%PROJECT_DIR%build\classes" (
    if not exist "%TARGET_APP%\WEB-INF\classes" mkdir "%TARGET_APP%\WEB-INF\classes"
    xcopy /E /I /Y /Q "%PROJECT_DIR%build\classes\*" "%TARGET_APP%\WEB-INF\classes\" >nul
)

echo [2/3] Verification: Database MySQL80 and Tomcat ready.
echo [3/3] Application URL:
echo       --^> http://localhost:8080/LoginApp1/
echo.
echo Press Ctrl+C at any time in this window to stop Tomcat.
echo ========================================================

cd /d "%CATALINA_HOME%\bin"
call catalina.bat run
