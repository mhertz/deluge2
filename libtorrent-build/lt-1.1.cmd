cd "%~dp0"
cd..
set BOOST_ROOT=%cd%\boost
set PYTHON_ROOT=%cd%\python
set PYTHON_ROOT2="%PYTHON_ROOT:\=/%"
set OPENSSL=%cd%\OpenSSL-Win64
set BOOST_BUILD_PATH=%BOOST_ROOT%\tools\build
set PATH=%PATH%;%BOOST_BUILD_PATH%\src\engine\bin.ntx86_64;%BOOST_ROOT%;%cd%\python;%cd%\msys64\usr\bin
mkdir boost & curl -L https://dl.bintray.com/boostorg/release/1.66.0/source/boost_1_66_0.zip | bsdtar xf - --strip-components 1 -C boost
git clone https://github.com/arvidn/libtorrent -b RC_1_1 lt
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
for /f %%i in ('echo %var2% ^| cut -d. -f1-2 ^| tr -d .') do set PYTHONVER=%%i
for /f %%i in ('echo %var2% ^| cut -d. -f1-2') do set PYTHONVER2=%%i
mkdir python & curl -L https://www.nuget.org/api/v2/package/python/%var2% | bsdtar xf - -C python --include tools --strip-components 1
msys64\usr\bin\echo -e "Lib\nDLLs\nimport site" >> python\python%PYTHONVER%._pth
patch --binary boost/libs/python/src/converter/builtin_converters.cpp < "%~dp01.1-builtin_converters.patch"
for /f "delims=#" %%i in ('"%programfiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -version [16.0^,17.0^) -prerelease -products * -property installationPath') do call "%%i\VC\Auxiliary\Build\vcvars64.bat"
pushd boost
call bootstrap.bat
popd
pushd lt\bindings\python
echo using python : %PYTHONVER2% : %PYTHON_ROOT2% : %PYTHON_ROOT2%/include : %PYTHON_ROOT2%/libs ; > %BOOST_BUILD_PATH%\user-config.jam
b2 crypto=openssl libtorrent-link=static boost-link=static release optimization=speed stage_module --abbreviate-paths -j4 address-model=64 openssl-include=%OPENSSL%\include openssl-lib=%OPENSSL%\lib cflags="/GL" linkflags="/LTCG"
popd
copy /y lt\bindings\python\libtorrent.pyd libtorrent\lt1.1\Lib\site-packages
rd /s /q boost
rd /s /q boost 2>nul
rd /s /q lt
rd /s /q lt 2>nul
rd /s /q python
rd /s /q python 2>nul
