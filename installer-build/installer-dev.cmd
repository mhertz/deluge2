cd "%~dp0"
for /f %%i in ('dir /b ..\deluge-2* ^| findstr dev') do set var2=%%i
curl https://dl.miyuru.lk/geoip/maxmind/country/maxmind4.dat.gz | "%programfiles%\7-Zip\7z" x -si -tgzip -so > ..\%var2%\GeoIP.dat
C:\nsis\bin\makensis /DPROGRAM_VERSION=%var2:~7% /Dsrcdir=C:\deluge2\%var2% deluge-installer.nsi
