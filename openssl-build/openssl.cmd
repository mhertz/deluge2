cd "%~dp0"
cd ..
set PATH=%cd%\msys64\usr\bin;%PATH%
for /f %%i in ('git ls-remote --tags https://github.com/openssl/openssl ^| grep -E 'OpenSSL_[0-9]_[0-9]_[0-9][a-z]' ^| cut -d/ -f3 ^| tr -d "^{}" ^| cut -d_ -f2-4') do set var=%%i
curl -O https://slproweb.com/download/Win64OpenSSL-%var%.exe
openssl-build\innounp.exe -x Win64OpenSSL-%var%.exe
rd /s /q OpenSSL-Win64
rd /s /q OpenSSL-Win64 2>nul
move {app} OpenSSL-Win64
rd /s /q {cf}
rd /s /q {cf} 2>nul
del install_script.iss
copy /y OpenSSL-Win64\*.dll overlay\Lib\site-packages
for /f %%i in ('dir /b deluge-2* ^| findstr /v dev') do copy /y OpenSSL-Win64\*.dll %%i\Lib\site-packages
for /f %%i in ('dir /b deluge-2* ^| findstr dev') do copy /y OpenSSL-Win64\*.dll %%i\Lib\site-packages
del Win64OpenSSL-%var%.exe
