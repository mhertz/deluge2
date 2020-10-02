# Deluge Windows installer script
#
# Copyright (C) 2009 Jesper Lund <mail@jesperlund.com>
# Copyright (C) 2009 Andrew Resch <andrewresch@gmail.com>
# Copyright (C) 2009 John Garland <johnnybg@gmail.com>
#
# This file is part of Deluge and is licensed under GNU General Public License 3.0, or later.
# See LICENSE for more details.
#

# Script version; displayed when running the installer
!define DELUGE_INSTALLER_VERSION "1.0"

# Deluge program information
!define PROGRAM_NAME "Deluge"
#!define PROGRAM_VERSION
!define PROGRAM_WEB_SITE "http://deluge-torrent.org"
!define LICENSE_FILEPATH "LICENSE"
Unicode true
!include "x64.nsh"
!include "nsProcess.nsh"
!include LogicLib.nsh
!include "Sections.nsh"
!include StrContains.nsh

# Python files generated with bbfreeze
!define BUILD_DIR "$%onedrive%\Deluge2"
!define BBFREEZE_DIR "${BUILD_DIR}\deluge-bbfreeze-${PROGRAM_VERSION}"
!define INSTALLER_FILENAME "deluge-${PROGRAM_VERSION}.exe"

# Set default compressor
SetCompressor /FINAL /SOLID lzma
SetCompressorDictSize 64

# --- Interface settings ---
# Modern User Interface 2
!include MUI2.nsh
# Installer
!define MUI_ICON "deluge.ico"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_RIGHT
!define MUI_HEADERIMAGE_BITMAP "installer-top.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "installer-side.bmp"
#!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_FINISHPAGE_NOAUTOCLOSE
!define MUI_ABORTWARNING
# Start Menu Folder Page Configuration
!define MUI_STARTMENUPAGE_DEFAULTFOLDER ${PROGRAM_NAME}
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCR"
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\Deluge"
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
# Uninstaller
!define MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\modern-uninstall.ico"
!define MUI_HEADERIMAGE_UNBITMAP "installer-top.bmp"
!define MUI_WELCOMEFINISHPAGE_UNBITMAP "installer-side.bmp"
!define MUI_UNFINISHPAGE_NOAUTOCLOSE

!define MUI_FINISHPAGE_SHOWREADME ""
!define MUI_FINISHPAGE_SHOWREADME_NOTCHECKED
!define MUI_FINISHPAGE_SHOWREADME_TEXT "Create Desktop Shortcut"
!define MUI_FINISHPAGE_SHOWREADME_FUNCTION finishpageaction

# --- Start of Modern User Interface ---
Var StartMenuFolder
var Portable
var gtk_csd
# Welcome, License & Components pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE ${LICENSE_FILEPATH}
!define MUI_PAGE_CUSTOMFUNCTION_SHOW fullsize_tweak_components_page
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE compleave
!insertmacro MUI_PAGE_COMPONENTS
# Let the user select the installation directory
!insertmacro MUI_PAGE_DIRECTORY
!define MUI_PAGE_CUSTOMFUNCTION_PRE compleave2
!insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
!define MUI_PAGE_CUSTOMFUNCTION_PRE instFilesPre
    Function instFilesPre
      ${If} ${FileExists} "$INSTDIR\*"
        ${StrContains} $0 "${PROGRAM_NAME}" $INSTDIR
        ${If} $0 == ""
          StrCpy $INSTDIR "$INSTDIR\${PROGRAM_NAME}"
        ${endIf}
      ${endIf}
    FunctionEnd
# Run installation
!insertmacro MUI_PAGE_INSTFILES
# Popup Message if VC Redist missing
#Page Custom VCRedistMessage
# Display 'finished' page
!define MUI_PAGE_CUSTOMFUNCTION_SHOW SetFinishPageOptions
!insertmacro MUI_PAGE_FINISH
# Uninstaller pages
!insertmacro MUI_UNPAGE_INSTFILES
# Language files
!insertmacro MUI_LANGUAGE "English"

# --- Functions ---

!define /ifndef SWP_NOZORDER 4
!define /ifndef SWP_NOACTIVATE 0x10
Function fullsize_tweak_components_page
System::Call 'USER32::GetClientRect(p $mui.ComponentsPage, @ r0)' ; Get the size of the inner dialog
System::Call '*$0(i,i,i.r3,i.r4)' ; Extract the right and bottom members from RECT
System::Call 'USER32::SetWindowPos(p $mui.ComponentsPage.Components, p 0, i 0, i 0, i $3, i $4, i ${SWP_NOZORDER}|${SWP_NOACTIVATE})' ; Resize the components list
FunctionEnd

Function un.onUninstSuccess
    HideWindow
    MessageBox MB_ICONINFORMATION|MB_OK "$(^Name) was successfully removed from your computer." /SD IDOK
FunctionEnd

Function un.onInit
    MessageBox MB_ICONQUESTION|MB_YESNO|MB_DEFBUTTON2 "Do you want to completely remove $(^Name)?" /SD IDYES IDYES +2
    Abort
FunctionEnd

Function finishpageaction
    CreateShortCut "$DESKTOP\Deluge.lnk" "$INSTDIR\deluge.exe" "" "$INSTDIR\Lib\site-packages\deluge\ui\data\pixmaps\deluge.ico"
FunctionEnd

# --- Installation sections ---
!define PROGRAM_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PROGRAM_NAME}"
!define PROGRAM_UNINST_ROOT_KEY "HKLM"
!define PROGRAM_UNINST_FILENAME "$INSTDIR\deluge-uninst.exe"

BrandingText "${PROGRAM_NAME} Windows Installer v${DELUGE_INSTALLER_VERSION}"
Name "${PROGRAM_NAME} ${PROGRAM_VERSION}"
OutFile "${BUILD_DIR}\${INSTALLER_FILENAME}"
InstallDir "$PROGRAMFILES64\Deluge"

ShowInstDetails show
ShowUnInstDetails show

# Install main application
Section "Deluge Bittorrent Client" Section1
    SectionIn RO
    #!include "install_files.nsh"

    #SetOverwrite ifnewer
    RMDir /r /REBOOTOK $INSTDIR
    SetOutPath "$INSTDIR"
    File ${LICENSE_FILEPATH}
        File /r "${srcdir}\*.*"	
    WriteIniStr "$INSTDIR\homepage.url" "InternetShortcut" "URL" "${PROGRAM_WEB_SITE}"
	${If} $Portable = 0 
    Delete "$APPDATA\deluge\session.state"
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        SetShellVarContext all
        CreateDirectory "$SMPROGRAMS\$StartMenuFolder"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Deluge.lnk" "$INSTDIR\deluge.exe" "" "$INSTDIR\Lib\site-packages\deluge\ui\data\pixmaps\deluge.ico"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Website.lnk" "$INSTDIR\homepage.url"
        CreateShortCut "$SMPROGRAMS\$StartMenuFolder\Uninstall Deluge.lnk" ${PROGRAM_UNINST_FILENAME}
    !insertmacro MUI_STARTMENU_WRITE_END
${endif}
SectionEnd

# Create .torrent file association.
Section "Associate .torrent files with Deluge" Section2
    DeleteRegKey HKCR ".torrent"
    WriteRegStr HKCR ".torrent" "" "Deluge"
    WriteRegStr HKCR ".torrent" "Content Type" "application/x-bittorrent"

    DeleteRegKey HKCR "Deluge"
    WriteRegStr HKCR "Deluge" "" "Deluge"
    WriteRegStr HKCR "Deluge\Content Type" "" "application/x-bittorrent"
    WriteRegStr HKCR "Deluge\DefaultIcon" "" "$INSTDIR\Lib\site-packages\deluge\ui\data\pixmaps\deluge.ico"
    WriteRegStr HKCR "Deluge\shell" "" "open"
    WriteRegStr HKCR "Deluge\shell\open\command" "" '"$INSTDIR\deluge.exe" "%1"'
SectionEnd

# Create magnet uri association.
Section "Associate Magnet URI links with Deluge" Section3
    DeleteRegKey HKCR "Magnet"
    WriteRegStr HKCR "Magnet" "" "URL:Magnet Protocol"
    WriteRegStr HKCR "Magnet" "URL Protocol" ""
    WriteRegStr HKCR "Magnet\shell\open\command" "" '"$INSTDIR\deluge.exe" "%1"'
SectionEnd

Section /o "Libtorrent 1.1.x (latest)" Section4
    File /r ..\libtorrent\lt1.1\*.*
SectionEnd

Section "Libtorrent 1.2.x (latest)" Section5
SectionEnd

Section /o "Libtorrent 1.2.3 (fallback)" Section5b
    File /r ..\libtorrent\lt1.2.3\*.*
SectionEnd

Section /o "Portable install" Section6
    File /r ..\portable\normal\*.*
SectionEnd

Section /o "Mantis-dark theme" Section7
    File /r ..\themes\mantis-dark\*.*
SectionEnd

Section /o "Adwaita theme" Section8
    File /r ..\themes\adwaita\*.*
SectionEnd

Section /o "Adwaita-dark theme" Section9
    File /r ..\themes\adwaita-dark\*.*
SectionEnd

Section "Win32 theme" Section10
SectionEnd

Section /o "GTK_CSD=0 (possibly lower performance)" Section11
	${If} $Portable = 1 
    File /r ..\portable\gtk_csd\*.*
	${else}
    File /r ..\themes\gtk_csd\*.*
		${EndIf}
SectionEnd

Function compleave
${If} ${SectionIsSelected} ${Section6}
	StrCpy $INSTDIR "$EXEDIR\Deluge"
	StrCpy $Portable 1
${Else}
	StrCpy $INSTDIR "$PROGRAMFILES64\Deluge"
	StrCpy $Portable 0
        ${EndIf}
${If} ${SectionIsSelected} ${Section11}
	StrCpy $gtk_csd 1
        ${EndIf}
        FunctionEnd

Function compleave2
${If} ${SectionIsSelected} ${Section6}
	Abort
        ${EndIf}
FunctionEnd

Function .onSelChange
	${If} $0 = ${Section5}
    !insertmacro SelectSection "${Section5}"
    !insertmacro UnselectSection "${Section4}"
    !insertmacro UnselectSection "${Section5b}"
${ElseIf} $0 = ${Section4}
    !insertmacro SelectSection "${Section4}"
    !insertmacro UnselectSection "${Section5}"
    !insertmacro UnselectSection "${Section5b}"
${ElseIf} $0 = ${Section5b}
    !insertmacro SelectSection "${Section5b}"
    !insertmacro UnselectSection "${Section5}"
    !insertmacro UnselectSection "${Section4}"
${EndIf}
	${If} $0 = ${Section10}
    !insertmacro SelectSection "${Section10}"
    !insertmacro UnselectSection "${Section9}"
    !insertmacro UnselectSection "${Section8}"
    !insertmacro UnselectSection "${Section7}"
${ElseIf} $0 = ${Section9}
    !insertmacro SelectSection "${Section9}"
    !insertmacro UnselectSection "${Section10}"
    !insertmacro UnselectSection "${Section8}"
    !insertmacro UnselectSection "${Section7}"
${ElseIf} $0 = ${Section8}
    !insertmacro SelectSection "${Section8}"
    !insertmacro UnselectSection "${Section10}"
    !insertmacro UnselectSection "${Section9}"
    !insertmacro UnselectSection "${Section7}"
${ElseIf} $0 = ${Section7}
    !insertmacro SelectSection "${Section7}"
    !insertmacro UnselectSection "${Section10}"
    !insertmacro UnselectSection "${Section9}"
    !insertmacro UnselectSection "${Section8}"
${EndIf}
${If} $0 = ${Section6}
${AndIf} ${SectionIsSelected} ${Section6}
    !insertmacro UnselectSection "${Section2}"
    !insertmacro UnselectSection "${Section3}"
${ElseIf} $0 = ${Section2}
${AndIf} ${SectionIsSelected} ${Section2}
    !insertmacro UnselectSection "${Section6}"
${ElseIf} $0 = ${Section3}
${AndIf} ${SectionIsSelected} ${Section3}
    !insertmacro UnselectSection "${Section6}"
${EndIf}
!insertmacro StartRadioButtons $8
!insertmacro RadioButton ${Section4}
!insertmacro RadioButton ${Section5}
!insertmacro RadioButton ${Section5b}
!insertmacro EndRadioButtons
!insertmacro StartRadioButtons $9
!insertmacro RadioButton ${Section7}
!insertmacro RadioButton ${Section8}
!insertmacro RadioButton ${Section9}
!insertmacro RadioButton ${Section10}
!insertmacro EndRadioButtons
FunctionEnd

Function SetFinishPageOptions
${If} ${SectionIsSelected} ${Section6}
ShowWindow $mui.FinishPage.ShowReadme ${SW_HIDE}
${EndIf}
FunctionEnd

# Check for running Deluge instance.
Function .onInit
${IfNot} ${RunningX64}
MessageBox MB_OK|MB_ICONEXCLAMATION "x64 not detected - aborting"
    Abort
${EndIf}
    ${nsProcess::KillProcess} "deluge.exe" $R0
    ${nsProcess::KillProcess} "deluged.exe" $R0
    ${nsProcess::KillProcess} "deluge-web.exe" $R0
    ${nsProcess::KillProcess} "deluge-gtk.exe" $R0
    ${nsProcess::KillProcess} "deluge-debug.exe" $R0
    ${nsProcess::KillProcess} "deluge-web-debug.exe" $R0
    ${nsProcess::KillProcess} "deluged-debug.exe" $R0
    ${nsProcess::Unload}
    StrCpy $8 ${Section5}
    StrCpy $9 ${Section10}
FunctionEnd

LangString DESC_Section1 ${LANG_ENGLISH} "Install Deluge Bittorrent client."
LangString DESC_Section2 ${LANG_ENGLISH} "Select this option to let Deluge handle the opening of .torrent files."
LangString DESC_Section3 ${LANG_ENGLISH} "Select this option to let Deluge handle Magnet URI links from the web-browser."

!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${Section1} $(DESC_Section1)
    !insertmacro MUI_DESCRIPTION_TEXT ${Section2} $(DESC_Section2)
    !insertmacro MUI_DESCRIPTION_TEXT ${Section3} $(DESC_Section3)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

# Create uninstaller.
Section -Uninstaller
	${If} $Portable = 0 
    WriteUninstaller ${PROGRAM_UNINST_FILENAME}
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "DisplayName" "$(^Name) (x64)"
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "UninstallString" ${PROGRAM_UNINST_FILENAME}
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "DisplayIcon" "$INSTDIR\Lib\site-packages\deluge\ui\data\pixmaps\deluge.ico"
    WriteRegStr ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}" "Publisher" "Deluge Team"
		${EndIf}
SectionEnd

# --- Uninstallation section ---
Section Uninstall
    # Delete Deluge files.
    Delete "$INSTDIR\LICENSE"
    Delete "$INSTDIR\homepage.url"
    Delete ${PROGRAM_UNINST_FILENAME}
    RMDir /r /REBOOTOK $INSTDIR
    #!include "uninstall_files.nsh"

    # Delete Start Menu items.
    !insertmacro MUI_STARTMENU_GETFOLDER Application $StartMenuFolder
        SetShellVarContext all
        Delete "$SMPROGRAMS\$StartMenuFolder\Deluge.lnk"
        Delete "$SMPROGRAMS\$StartMenuFolder\Uninstall Deluge.lnk"
        Delete "$SMPROGRAMS\$StartMenuFolder\Website.lnk"
        RmDir "$SMPROGRAMS\$StartMenuFolder"
        DeleteRegKey /ifempty HKCR "Software\Deluge"

    Delete "$DESKTOP\Deluge.lnk"

    # Delete registry keys.
    DeleteRegKey ${PROGRAM_UNINST_ROOT_KEY} "${PROGRAM_UNINST_KEY}"
    # Only delete the .torrent association if Deluge owns it
    ReadRegStr $1 HKCR ".torrent" ""
    StrCmp $1 "Deluge" 0 DELUGE_skip_delete
        # Delete the key since it is owned by Deluge; afterwards there is no .torrent association
        DeleteRegKey HKCR ".torrent"
    DELUGE_skip_delete:
    # This key is only used by Deluge, so we should always delete it
    DeleteRegKey HKCR "Deluge"
SectionEnd

# Add version info to installer properties.
VIProductVersion "${DELUGE_INSTALLER_VERSION}.0.0"
VIAddVersionKey ProductName ${PROGRAM_NAME}
VIAddVersionKey Comments "Deluge Bittorrent Client"
VIAddVersionKey CompanyName "Deluge Team"
VIAddVersionKey LegalCopyright "Deluge Team"
VIAddVersionKey FileDescription "${PROGRAM_NAME} Application Installer"
VIAddVersionKey FileVersion "${DELUGE_INSTALLER_VERSION}.0.0"
VIAddVersionKey ProductVersion "${PROGRAM_VERSION}.0"
VIAddVersionKey OriginalFilename ${INSTALLER_FILENAME}
