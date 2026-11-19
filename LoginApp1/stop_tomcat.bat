@echo off
setlocal

echo ========================================================
echo  Stopping Apache Tomcat Server...
echo ========================================================

set "CATALINA_HOME=C:\Users\mokta\Downloads\apache-tomcat-9.0.121"
set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-8.0.482.8-hotspot"

cd /d "%CATALINA_HOME%\bin"
call shutdown.bat

echo.
echo Checking port 8080 status...
powershell -Command "$p = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue; if ($p) { Write-Host 'Terminating hanging port 8080 process...' -ForegroundColor Yellow; Stop-Process -Id $p.OwningProcess -Force -ErrorAction SilentlyContinue; Write-Host 'Port 8080 freed.' -ForegroundColor Green } else { Write-Host 'Tomcat stopped successfully. Port 8080 is free.' -ForegroundColor Green }"

echo ========================================================
