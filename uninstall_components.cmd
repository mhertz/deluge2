cd "%~dp0"
rd /s /q msys64
rd /s /q msys64 2>nul
rd /s /q nsis
rd /s /q nsis 2>nul
"%programfiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" --installPath "%~dp0msvc" /uninstall -q
