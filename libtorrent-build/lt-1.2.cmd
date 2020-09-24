cd "%~dp0"
curl -LO https://dl.bintray.com/boostorg/release/1.74.0/source/boost_1_74_0.7z
"%programfiles%\7-Zip\7z.exe" x boost_*.7z -oC:
move C:\boost_* C:\boost
set BOOST_ROOT=c:\boost
set BOOST_BUILD_PATH=%BOOST_ROOT%\tools\build
set PATH=%PATH%;%BOOST_BUILD_PATH%\src\engine\bin.ntx86;%BOOST_ROOT%;C:\python;C:\msys64\usr\bin
git clone https://github.com/arvidn/libtorrent C:/libtorrent
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
mkdir C:\python & curl -L https://www.nuget.org/api/v2/package/python/%var2% | C:\msys64\usr\bin\bsdtar -xf - -C C:\python --include tools --strip-components 1
C:\msys64\usr\bin\echo -e "Lib\nDLLs\nimport site" >> C:\python\python38._pth
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build\vcvars64.bat"
cd c:\boost
call bootstrap.bat
cd "%~dp0"
patch C:/libtorrent/bindings/python/setup.py < 1.2-setup.patch
cd C:\libtorrent\bindings\python
python setup.py build --bjam
copy /y libtorrent.pyd C:\deluge2\overlay\Lib\site-packages
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr /v dev') do copy /y libtorrent.pyd C:\deluge2\%%i\Lib\site-packages
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do copy /y libtorrent.pyd C:\deluge2\%%i\Lib\site-packages
cd "%~dp0"
rd /s /q C:\boost
rd /s /q C:\boost
rd /s /q C:\libtorrent
rd /s /q C:\libtorrent
rd /s /q C:\python
rd /s /q C:\python
del boost_*.7z
