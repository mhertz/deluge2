cd "%~dp0"
rd /s /q msys64
rd /s /q msys64 2>nul
rd /s /q nsis
rd /s /q nsis 2>nul
net sess>nul 2>&1||(echo(CreateObject("Shell.Application"^).ShellExecute"%~0",,,"RunAs",1:CreateObject("Scripting.FileSystemObject"^).DeleteFile(wsh.ScriptFullName^)>"%temp%\%~nx0.vbs"&start wscript.exe "%temp%\%~nx0.vbs"&exit)
"%programfiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" uninstall --installPath "%~dp0msvc" --q
"%programfiles(x86)%\Microsoft Visual Studio\Installer\vswhere" -products * -prerelease -legacy -format json | find "[]" && "%programfiles(x86)%\Microsoft Visual Studio\Installer\vs_installer.exe" /uninstall --q && rd /s /q "%programfiles(x86)%\Microsoft Visual Studio" 
