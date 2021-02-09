cd "%~dp0"
pushd..
set PATH=%cd%\msys64\usr\bin;%PATH%
popd
for /f %%i in ('dir /b /a:d ..\deluge-2* ^| findstr /v dev') do set var1=%%i
for /f %%i in ('dir /b /a:d ..\deluge-2* ^| findstr dev') do set var2=%%i
curl https://mailfud.org/geoip-legacy/GeoIP.dat.gz | gzip -d -c > ..\%var1%\GeoIP.dat
curl https://mailfud.org/geoip-legacy/GeoIP.dat.gz | gzip -d -c > ..\%var2%\GeoIP.dat
curl https://mailfud.org/geoip-legacy/GeoIPv6.dat.gz | gzip -d -c > ..\%var2%\GeoIPv6.dat
del ..\deluge-2*.exe 2>nul
..\nsis\makensis /DPROGRAM_VERSION=%var1:~7% /Dsrcdir=..\%var1% deluge-installer.nsi
..\nsis\makensis /DPROGRAM_VERSION=%var2:~7% /Dsrcdir=..\%var2% deluge-installer.nsi
