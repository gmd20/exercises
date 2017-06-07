@echo off
set PATH=%PATH%;%cd%/iPhone_syslog

set LOG_FILE=iphone_syslog_%date:~0,4%-%date:~5,2%-%date:~8,2%_%time:~0,2%-%time:~3,2%-%time:~6,2%.txt

echo ========================================================================>> %LOG_FILE%
iphone_info >> %LOG_FILE%
echo ========================================================================>> %LOG_FILE%
iphone_logcat >> %LOG_FILE%

pause
