cd "%~dp0"
set PATH=C:\msys64\usr\bin;%PATH%
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
mkdir C:\python & curl -L https://www.python.org/ftp/python/%var2%/python-%var2%-embed-amd64.zip | C:\msys64\usr\bin\bsdtar -xf - -C C:\python
C:\msys64\usr\bin\sed.exe -i 's/#import/import/' C:\python\python38._pth
curl https://bootstrap.pypa.io/get-pip.py | C:\python\python.exe
for /f %%i in ('dir /b pycairo-*-win_amd64.whl') do C:\python\Scripts\pip.exe install %%i
for /f %%i in ('dir /b PyGObject-*-win_amd64.whl') do C:\python\Scripts\pip.exe install %%i
C:\python\Scripts\pip.exe install pygeoip
C:\python\Scripts\pip.exe install requests
for /f %%i in ('echo %var2% ^| cut -c 1-3 ^| tr -d "."') do set var3=%%i
for /f %%i in ('git ls-remote --tags --refs https://github.com/twisted/twisted ^| cut -f2 ^| sort --version-sort ^| cut -c 19- ^| tail -1') do C:\python\Scripts\pip install https://download.lfd.uci.edu/pythonlibs/w3jqiv8s/Twisted-%%i-cp%var3%-cp%var3%-win_amd64.whl
for /f %%i in ('git ls-remote --tags --refs https://github.com/dvarrazzo/py-setproctitle ^| cut -f2 ^| sort --version-sort ^| cut -c 19- ^| tail -1') do C:\python\Scripts\pip install https://download.lfd.uci.edu/pythonlibs/w3jqiv8s/setproctitle-%%i-cp%var3%-cp%var3%"-win_amd64.whl
copy /y ..\loaders\* C:\python\Lib\site-packages\pip\_vendor\distlib
C:\python\Scripts\pip.exe install git+https://github.com/deluge-torrent/deluge
for /f %%i in ('dir /b C:\python\Lib\site-packages\deluge-*') do set var=%%i
patch C:/python/Lib/site-packages/twisted/internet/_glibbase.py < _glibbase.patch
patch C:/python/Lib/site-packages/deluge/ui/client.py < client.patch
patch C:/python/Lib/site-packages/deluge/ui/gtk3/common.py < common.patch
patch C:/python/Lib/site-packages/deluge/core/preferencesmanager.py < preferencesmanager.patch
curl https://github.com/deluge-torrent/deluge/commit/23b019e39c151d76933057c7a237c6f2193cf88e.patch | patch.exe -d C:/python/Lib/site-packages -p1 --no-backup-if-mismatch
patch C:/python/Lib/site-packages/deluge/log.py < logging.patch
patch -R C:/python/Lib/site-packages/cairo/__init__.py < pycairo_py3_8_load_dll.patch
patch -R C:/python/Lib/site-packages/gi/__init__.py < pygobject_py3_8_load_dll.patch
copy C:\python\Scripts\deluge.exe C:\python
copy C:\python\Scripts\deluge-console.exe C:\python
copy C:\python\Scripts\deluged.exe C:\python
copy C:\python\Scripts\deluged-debug.exe C:\python
copy C:\python\Scripts\deluge-debug.exe C:\python
copy C:\python\Scripts\deluge-gtk.exe C:\python
copy C:\python\Scripts\deluge-web.exe C:\python
copy C:\python\Scripts\deluge-web-debug.exe C:\python
rd /s /q C:\python\Scripts
rd /s /q C:\python\Scripts
C:\python\python.exe portable.py -f C:\python\deluged.exe -s c:\python\python.exe -r pythonw.exe
C:\python\python.exe portable.py -f C:\python\deluged-debug.exe -s c:\python\python.exe -r python.exe
C:\python\python.exe portable.py -f C:\python\deluge-web.exe -s c:\python\python.exe -r pythonw.exe
C:\python\python.exe portable.py -f C:\python\deluge-web-debug.exe -s c:\python\python.exe -r python.exe
C:\python\python.exe portable.py -f C:\python\deluge.exe -s c:\python\pythonw.exe -r pythonw.exe
C:\python\python.exe portable.py -f C:\python\deluge-debug.exe -s c:\python\python.exe -r python.exe
C:\python\python.exe portable.py -f C:\python\deluge-gtk.exe -s c:\python\pythonw.exe -r pythonw.exe
C:\python\python.exe portable.py -f C:\python\deluge-console.exe -s c:\python\python.exe -r python.exe
C:\python\python.exe fixdeluged.py
C:\python\python.exe fixdeluge-web.py
xcopy /ehq C:\deluge2\overlay C:\python
xcopy /ehq C:\deluge2\themes\icons C:\python\data\share\icons\
del C:\python\Lib\site-packages\easy_install.py
del C:\python\Lib\site-packages\PyWin32.chm
rd /s /q C:\python\Lib\site-packages\PIL
rd /s /q C:\python\Lib\idlelib
rd /s /q C:\python\Lib\distutils
rd /s /q C:\python\Lib\site-packages\pip
rd /s /q C:\python\Lib\site-packages\setuptools
rd /s /q C:\python\Lib\site-packages\pythonwin
rd /s /q C:\python\Doc
rd /s /q C:\python\libs
rd /s /q C:\python\include
rd /s /q C:\python\Tools
rd /s /q C:\python\tcl
rd /s /q C:\deluge2\deluge-%var%
rd /s /q C:\deluge2\deluge-%var%
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do rd /s /q C:\deluge2\%%i
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do rd /s /q C:\deluge2\%%i
xcopy /ehq C:\python C:\deluge2\%var:~0,-10%\
rd /s /q C:\python
rd /s /q C:\python
