cd "%~dp0"
pushd..
set PATH=%cd%\msys64\usr\bin;%PATH%
popd
for /f %%i in ('dir /b ..\deluge-2* ^| findstr /v dev') do set var1=%%i
curl https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | ..\msys64\usr\lib\p7zip\7z x -si -tgzip -so > ..\%var1%\GeoIP.dat
..\nsis\makensis /DPROGRAM_VERSION=%var1:~7% /Dsrcdir=..\%var1% deluge-installer.nsi
pause
