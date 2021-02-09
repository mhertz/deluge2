cd "%~dp0"
pushd..
set PATH=%cd%\msys64\usr\bin;%PATH%
popd
for /f %%i in ('dir /b /a:d ..\deluge-2* ^| findstr /v dev') do set var1=%%i
curl https://mailfud.org/geoip-legacy/GeoIP.dat.gz | gzip -d -c > ..\%var1%\GeoIP.dat
for /f %%i in ('dir /b /a:-d ..\deluge-2* ^| findstr /v dev') do del ..\%%i
..\nsis\makensis /DPROGRAM_VERSION=%var1:~7% /Dsrcdir=..\%var1% deluge-installer.nsi
