@echo off
@title Processing M3 fake fan installation
@setlocal

set LOGIN=root
set PWD=root
set PTY_ROOT=C:\Program Files\PuTTY
set PORT=22

if not exist ips.txt (
	echo Unable to find ips.txt, please create file that contains all ip addresses of M3 asics that you need to process
    goto end
)

for /F "tokens=1,2,3,4 delims=;@" %%a in (ips.txt) do call :processLine %%a %%b %%c %%d
echo Processing has finished
goto end

:processLine
set a_ip=%1
set a_login=%LOGIN%
set a_pwd=%PWD%
set a_port=%PORT%
echo Processing %a_ip% ...

if not "%2."=="." ( 
	set a_login=%2
)

if not "%3."=="." ( 
	set a_pwd=%3
)
	
if not "%4."=="." ( 
	set a_port=%4
)

echo y | "%PTY_ROOT%\plink.exe" -ssh -P %a_port% -pw %a_pwd% %a_login%@%a_ip% mount -o remount,rw / ^&^& chmod +w /etc/init.d/boot ^&^& echo "sed -i.back -e 's|reload_config|reload_config\n\texec /etc/fake_fan.sh|g' /etc/init.d/boot"
echo y | "%PTY_ROOT%\pscp.exe" -scp -P %a_port% -pw %a_pwd% fake_fan.sh %a_login%@%a_ip%:/etc/
echo y | "%PTY_ROOT%\plink.exe" -ssh -P %a_port% -pw %a_pwd% %a_login%@%a_ip% chmod +x /etc/fake_fan.sh ^&^& exec /etc/fake_fan.sh"
goto :eof

:end
pause