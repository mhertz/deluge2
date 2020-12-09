cd "%~dp0"
pushd..
set PATH=%cd%\msys64\usr\bin;%PATH%
popd
for /f %%i in ('dir /b /a:d ..\deluge-2* ^| findstr /v dev') do set var1=%%i
curl https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | gzip -d -c > ..\%var1%\GeoIP.dat
del ..\deluge-*.exe 2>nul
..\nsis\makensis /DPROGRAM_VERSION=%var1:~7% /Dsrcdir=..\%var1% deluge-installer.nsi
pause
