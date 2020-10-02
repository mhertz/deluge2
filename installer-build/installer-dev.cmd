cd "%~dp0"
set PATH=%cd%\msys64\usr\bin;%PATH%
for /f %%i in ('dir /b ..\deluge-2* ^| findstr dev') do set var2=%%i
curl https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | ..\msys64\usr\lib\p7zip\7z x -si -tgzip -so > ..\%var2%\GeoIP.dat
..\nsis\makensis /DPROGRAM_VERSION=%var2:~7% /Dsrcdir=..\%var2% deluge-installer.nsi
pause
