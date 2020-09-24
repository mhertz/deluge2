cd "%~dp0"
set PATH=C:\msys64\usr\bin;%PATH%
for /f %%i in ('git ls-remote --tags https://github.com/openssl/openssl ^| grep -E 'OpenSSL_[0-9]_[0-9]_[0-9][a-z]' ^| cut -d/ -f3 ^| tr -d "^{}" ^| cut -d_ -f2-4') do set var=%%i
curl -O https://slproweb.com/download/Win64OpenSSL-%var%.exe
innounp.exe -x Win64OpenSSL-%var%.exe
rd /s /q C:\OpenSSL-Win64
rd /s /q C:\OpenSSL-Win64
move {app} C:\OpenSSL-Win64
rd /s /q {cf}
rd /s /q {cf}
del install_script.iss
copy /y C:\OpenSSL-Win64\*.dll C:\deluge2\overlay\Lib\site-packages
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr /v dev') do copy /y C:\OpenSSL-Win64\*.dll C:\deluge2\%%i\Lib\site-packages
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do copy /y C:\OpenSSL-Win64\*.dll C:\deluge2\%%i\Lib\site-packages
del Win64OpenSSL-%var%.exe
