cd "%~dp0"
set PATH=%~dp0msys64\usr\bin;%PATH%
powershell -executionpolicy remotesigned -Command "Invoke-WebRequest https://github.com/msys2/msys2-installer/releases/download/nightly-x86_64/msys2-base-x86_64-latest.sfx.exe -OutFile msys2-base-x86_64-latest.sfx.exe"
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
curl.exe -kO https://download.visualstudio.microsoft.com/download/pr/68d6b204-9df0-4fcc-abcc-08ee0eff9cb2/0b833c703ae7532e54db2d1926e2c3d2e29a7c053358f8c635498ab25bb8c590/vs_BuildTools.exe
vs_buildtools.exe --quiet --add Microsoft.VisualStudio.Workload.VCTools --includeRecommended --installPath "%~dp0msvc" --wait
del msys2-base-x86_64-latest.* NsProcess.zip strawberry-perl-*-64bit.zip vs_BuildTools.exe
rd /s /q nsprocess
rd /s /q nsprocess 2>nul
