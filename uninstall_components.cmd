cd "%~dp0"
rd /s /q msys64
rd /s /q msys64 2>nul
rd /s /q gtk-cache
rd /s /q gtk-cache 2>nul
rd /s /q OpenSSL-Win64
rd /s /q OpenSSL-Win64 2>nul
rd /s /q nsis
rd /s /q nsis 2>nul
"%programfiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" /uninstall -q
rd /s /q "%programfiles(x86)%\Microsoft Visual Studio"
rd /s /q "%programfiles(x86)%\Microsoft Visual Studio" 2>nul
