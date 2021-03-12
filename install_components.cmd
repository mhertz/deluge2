cd "%~dp0"
set PATH=%~dp0msys64\usr\bin;%PATH%
powershell -executionpolicy remotesigned -Command "Start-BitsTransfer "http://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe"
msys2-base-x86_64-latest.sfx.exe
del msys2-base-x86_64-latest.sfx.exe
bash -lic "pacman -Syu --noconfirm"
bash -lic "pacman -Syu --noconfirm"
bash -lic "pacman -S diffutils patch git --noconfirm"
for /f %%i in ('curl https://nsis.sourceforge.io/Download ^| grep Notes ^| grep -o v.* ^| tr -d v ^| cut -d'^"' -f1') do set var=%%i
mkdir nsis & curl -L "https://sourceforge.net/projects/nsis/files/NSIS %var:~0,1%/%var%/nsis-%var%.zip/download" | bsdtar xf - --strip-components 1 -C nsis
curl.exe -kO https://nsis.sourceforge.io/mediawiki/images/1/18/NsProcess.zip
mkdir nsprocess & bsdtar xf NsProcess.zip -C nsprocess
move nsprocess\Plugin\nsProcessW.dll nsis\Plugins\x86-unicode\nsProcess.dll
move nsprocess\Include\nsProcess.nsh nsis\Include
curl.exe -k https://git.landicorp.com/electron-downloadtool/electron-downloadtool/-/raw/5da62a7d62329bd9afe7a1bfda3f759d6bc04c80/node_modules/electron-builder/templates/nsis/include/StrContains.nsh > nsis\Include\strContains.nsh
for /f %%i in ('curl https://www.nasm.us/ ^| grep releasebuilds/[0-9] ^| cut -d^'^"^' -f2') do set var=%%i
mkdir nasm & curl -L %var%win64/nasm-%var:~42,-1%-win64.zip | bsdtar xf - --strip-components 1 -C nasm
for /f %%i in ('curl https://strawberryperl.com/ ^| grep download/[0-9] ^| cut -d/ -f3') do set var=%%i
mkdir perl
curl -O https://strawberryperl.com/download/%var%/strawberry-perl-%var%-64bit.zip
bsdtar xf strawberry-perl-%var%-64bit.zip --exclude="^c" -C perl
if exist "%programfiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" "%programfiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -version [16.0,17.0) -prerelease -products * -nologo -requires Microsoft.Component.MSBuild Microsoft.VisualStudio.Component.VC.Tools.x86.x64 | findstr . && set dirty=1
if exist "%programfiles(x86)%\Windows kits\10" if not defined dirty curl -LO https://aka.ms/vs/16/release/vs_BuildTools.exe && vs_BuildTools.exe --quiet --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows10SDK.19041 --installPath "%~dp0msvc" --wait && del vs_BuildTools.exe
del msys2-base-x86_64-latest.* NsProcess.zip strawberry-perl-*-64bit.zip
rd /s /q nsprocess
rd /s /q nsprocess 2>nul
