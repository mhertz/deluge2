cd "%~dp0"
set DOWNLOAD_DIR=C:\gtk-cache
set PYTHONPATH=C:\python
set MSYSPATH=C:\msys64\usr\bin
set PATH=%PYTHONPATH%;%PYTHONPATH%\Scripts;C:\gtk-build\gtk\x64\release\bin;%MSYSPATH%;%PATH%
set platform=x64
set VS_VER=16
set VS_VCVARS=14.25
set arch=amd64
set VSCMD_DEBUG=1
for /f %%i in ('curl -s https://www.python.org/ ^| grep "Latest: " ^| cut -d/ -f5 ^| cut -d" " -f2 ^| tr -d "<"') do set var2=%%i
for /f %%i in ('echo %var2% ^| cut -d. -f1-2 ^| tr -d .') do set PYTHONVER=%%i
mkdir C:\python & curl -L https://www.nuget.org/api/v2/package/python/%var2% | C:\msys64\usr\bin\bsdtar -xf - -C C:\python --include tools --strip-components 1
C:\msys64\usr\bin\echo -e "C:/gtk-build/build/x64/release/libcroco/win32\nLib\nDLLs\nimport site" >> C:\python\python38._pth
curl https://bootstrap.pypa.io/get-pip.py | C:\python\python.exe
cd "C:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools\VC\Auxiliary\Build"
call vcvars64.bat
git clone https://github.com/wingtk/gvsbuild C:\gtk-build\github\gvsbuild
cd C:\gtk-build\github\gvsbuild
copy "%~dp0win32.patch" patches\gtk3-24
sed -i 's/gtk3_24(Tarball/gtk3_24(GitRepo/' gvsbuild\projects.py
sed -i "/prj_dir='gtk3-24',/{n;N;d}" gvsbuild\projects.py
sed -i "/prj_dir='gtk3-24',/a\            repo_url = 'https:\/\/gitlab.gnome.org\/GNOME\/gtk.git',\n            fetch_submodules = False,\n            tag = 'gtk-3-24'," gvsbuild\projects.py
sed -i "/'gtk_update_icon_cache.patch',/a\                'win32.patch'," gvsbuild\projects.py
python build.py -d build --gtk3-ver=3.24 --archives-download-dir=%DOWNLOAD_DIR% --vs-ver=%VS_VER% --platform=x64 --vs-install-path="c:\Program Files (x86)\Microsoft Visual Studio\2019\BuildTools" --python-dir=C:\python -k --enable-gi --py-wheel --python-ver=%var2% enchant gtk3-full pycairo pygobject lz4 --skip gtksourceview3,emeus,clutter,adwaita-icon-theme --capture-out --print-out
cd "%~dp0"
rd /s /q C:\python
rd /s /q C:\python
del C:\gtk-build\gtk\x64\release\bin\*.exe
del C:\gtk-build\gtk\x64\release\bin\*.pdb
del C:\gtk-build\gtk\x64\release\\bin\gdbus-codegen
del C:\gtk-build\gtk\x64\release\\bin\g-ir-annotation-tool
del C:\gtk-build\gtk\x64\release\bin\g-ir-scanner
del C:\gtk-build\gtk\x64\release\bin\glib-genmarshal
del C:\gtk-build\gtk\x64\release\bin\glib-mkenums
del C:\gtk-build\gtk\x64\release\bin\gtester-report
del C:\gtk-build\gtk\x64\release\etc\gtk-3.0\im-multipress.conf
del C:\gtk-build\gtk\x64\release\lib\harfbuzz.lib
del C:\gtk-build\gtk\x64\release\lib\*.pdb
del C:\gtk-build\gtk\x64\release\lib\enchant\*.pdb
del C:\deluge2\deluge-build\pycairo-*-win_amd64.whl
del C:\deluge2\deluge-build\PyGObject-*-win_amd64.whl
move /y C:\gtk-build\gtk\x64\release\python\*.whl C:\deluge2\deluge-build
rd /s /q C:\gtk-build\gtk\x64\release\include 
rd /s /q C:\gtk-build\gtk\x64\release\libexec
rd /s /q C:\gtk-build\gtk\x64\release\python
rd /s /q C:\gtk-build\gtk\x64\release\share\aclocal 
rd /s /q C:\gtk-build\gtk\x64\release\share\cogl-1.0
rd /s /q C:\gtk-build\gtk\x64\release\share\doc 
rd /s /q C:\gtk-build\gtk\x64\release\share\gettext 
rd /s /q C:\gtk-build\gtk\x64\release\share\gir-1.0 
rd /s /q C:\gtk-build\gtk\x64\release\share\gobject-introspection-1.0
rd /s /q C:\gtk-build\gtk\x64\release\share\gtk-2.0 
rd /s /q C:\gtk-build\gtk\x64\release\share\gtk-3.0
rd /s /q C:\gtk-build\gtk\x64\release\share\installed-tests 
rd /s /q C:\gtk-build\gtk\x64\release\share\man 
rd /s /q C:\gtk-build\gtk\x64\release\share\pkgconfig
rd /s /q C:\gtk-build\gtk\x64\release\share\thumbnailers
rd /s /q C:\gtk-build\gtk\x64\release\share\icons\Adwaita\cursors
del C:\gtk-build\gtk\x64\release\lib\gdk-pixbuf-2.0\2.10.0\loaders\*.pdb
del C:\gtk-build\gtk\x64\release\lib\gobject-introspection\giscanner\_giscanner.pdb
move C:\deluge2\overlay\data\bin\msvcp140.dll C:\gtk-build\gtk\x64\release\bin
move C:\deluge2\overlay\data\etc\gtk-3.0\settings.ini C:\gtk-build\gtk\x64\release\etc\gtk-3.0
rd /s /q C:\gtk-build\gtk\x64\release\share\icons
rd /s /q C:\gtk-build\gtk\x64\release\share\icons
move C:\deluge2\overlay\data\share\icons C:\gtk-build\gtk\x64\release\share
rd /s /q  C:\deluge2\overlay\data
rd /s /q  C:\deluge2\overlay\data
move C:\gtk-build\gtk\x64\release C:\deluge2\overlay\data
rd /s /q C:\gtk-build
rd /s /q C:\gtk-build
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr /v dev') do rd /s /q C:\deluge2\%%i\data
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr /v dev') do rd /s /q C:\deluge2\%%i\data
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do rd /s /q C:\deluge2\%%i\data
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do rd /s /q C:\deluge2\%%i\data
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr /v dev') do xcopy /ehq C:\deluge2\overlay\data C:\deluge2\%%i\data\
for /f %%i in ('dir /b C:\deluge2\deluge-2* ^| findstr dev') do xcopy /ehq C:\deluge2\overlay\data C:\deluge2\%%i\data\
pause
