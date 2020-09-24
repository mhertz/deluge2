cd "%~dp0"
cmd /c openssl-build\openssl.cmd
curl -O http://repo.msys2.org/distrib/msys2-x86_64-latest.tar.xz
"%programfiles%\7-Zip\7z.exe" x msys2-x86_64-latest.tar.xz
"%programfiles%\7-Zip\7z.exe" x msys2-x86_64-latest.tar -oC:
C:\msys64\usr\bin\bash -lic "pacman -Syu --noconfirm"
C:\msys64\usr\bin\bash -lic "pacman -Syu --noconfirm"
C:\msys64\usr\bin\bash -lic "pacman -S diffutils patch git --noconfirm"
curl -LO https://prdownloads.sourceforge.net/nsis/nsis-3.06.1-setup.exe
"%programfiles%\7-Zip\7z.exe" x -oC:\nsis -x!$PLUGINSDIR\* nsis-3.06.1-setup.exe
curl.exe -kO https://nsis.sourceforge.io/mediawiki/images/1/18/NsProcess.zip
"%programfiles%\7-Zip\7z.exe" x NsProcess.zip -onsprocess
move nsprocess\Plugin\nsProcessW.dll C:\nsis\Plugins\x86-unicode\nsProcess.dll
move nsprocess\Include\nsProcess.nsh C:\nsis\Include
curl.exe -k https://git.landicorp.com/electron-downloadtool/electron-downloadtool/-/raw/5da62a7d62329bd9afe7a1bfda3f759d6bc04c80/node_modules/electron-builder/templates/nsis/include/StrContains.nsh > C:\nsis\Include\strContains.nsh
curl.exe -kO https://download.visualstudio.microsoft.com/download/pr/68d6b204-9df0-4fcc-abcc-08ee0eff9cb2/0b833c703ae7532e54db2d1926e2c3d2e29a7c053358f8c635498ab25bb8c590/vs_BuildTools.exe
vs_buildtools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --wait
del nsis-3.06.1-setup.exe msys2-x86_64-latest.tar* NsProcess.zip vs_BuildTools.exe
rd /s /q nsprocess
rd /s /q nsprocess
