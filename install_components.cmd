cd "%~dp0"
set PATH=%~dp0msys64\usr\bin;%PATH%
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest http://repo.msys2.org/distrib/msys2-x86_64-latest.tar.xz -OutFile msys2-x86_64-latest.tar.xz"
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://github.com/uuksu/7z.NET/raw/master/7z.NET/7za.exe -OutFile 7za.exe"
7za x msys2-x86_64-latest.tar.xz
7za x msys2-x86_64-latest.tar
bash -lic "pacman -Syu --noconfirm"
bash -lic "pacman -Syu --noconfirm"
bash -lic "pacman -S diffutils patch git p7zip --noconfirm"
cmd /c openssl-build\openssl.cmd
for /f %%i in ('curl https://nsis.sourceforge.io/Download ^| grep Notes ^| grep -o v.* ^| tr -d v ^| cut -d'"' -f1') do set var=%%i
curl -L "https://sourceforge.net/projects/nsis/files/NSIS %var:~0,1%/%var%/nsis-%var%.zip/download" >nsis-%var%.zip
msys64\usr\lib\p7zip\7z x nsis-%var%.zip
move nsis-%var% nsis
curl.exe -kO https://nsis.sourceforge.io/mediawiki/images/1/18/NsProcess.zip
msys64\usr\lib\p7zip\7z x NsProcess.zip -onsprocess
move nsprocess\Plugin\nsProcessW.dll nsis\Plugins\x86-unicode\nsProcess.dll
move nsprocess\Include\nsProcess.nsh nsis\Include
curl.exe -k https://git.landicorp.com/electron-downloadtool/electron-downloadtool/-/raw/5da62a7d62329bd9afe7a1bfda3f759d6bc04c80/node_modules/electron-builder/templates/nsis/include/StrContains.nsh > nsis\Include\strContains.nsh
curl.exe -kO https://download.visualstudio.microsoft.com/download/pr/68d6b204-9df0-4fcc-abcc-08ee0eff9cb2/0b833c703ae7532e54db2d1926e2c3d2e29a7c053358f8c635498ab25bb8c590/vs_BuildTools.exe
vs_buildtools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --wait
del nsis-%var%.zip msys2-x86_64-latest.tar* NsProcess.zip vs_BuildTools.exe 7za.exe
rd /s /q nsprocess
rd /s /q nsprocess 2>nul
