;NSIS Installer
;Copyright (C) 2011-2024 MicroSIP (www.microsip.org)

;--------------------------------
!include "MUI2.nsh"
!include "Library.nsh"
!include "FileFunc.nsh"  
!include "LogicLib.nsh"

;--------------------------------
!include "config.nsh"

!define /date CurrentYear "%Y"
 
!ifndef APPALLUSERS
  !define HKKEY HKCU
!else
  !define HKKEY HKLM
!endif

!ifndef PRODUCT_NAME_INTERNAL
  !define PRODUCT_NAME_INTERNAL "${PRODUCT_NAME}"
!endif

!ifndef FILE_ICON_INDEX
  !define FILE_ICON_INDEX "0"
!endif

!ifndef APPICON
  !define APPICON "..\res\microsip.ico"
!endif

!ifndef RINGTONE
  !define RINGTONE "common\ringtone.wav"
!endif
!ifndef RINGING2
  !define RINGING2 "common\ringing2.wav"
!endif
!ifndef HANGUP
  !define HANGUP "common\hangup.wav"
!endif
!ifndef APPLICENSE
  !define APPLICENSE "License.txt"
!endif

!ifndef PREFIX
!ifdef CUSTOM
  !define PREFIX "langpack_custom\"
!else
  !define PREFIX "langpack\"
!endif
!endif

!ifdef THEME_MODERN
  !insertmacro MUI_DEFAULT MUI_ICON "${APPICON}"
  !insertmacro MUI_DEFAULT MUI_UNICON "${APPICON}"
!ifndef APPHEADERBMP
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\nsis3-branding.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP  "${NSISDIR}\Contrib\Graphics\Header\nsis3-branding.bmp"
!else
  !define MUI_HEADERIMAGE_BITMAP "${APPHEADERBMP}"
  !define MUI_HEADERIMAGE_UNBITMAP "${APPHEADERBMP}"
!endif
  !insertmacro MUI_DEFAULT MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-branding.bmp"
  !insertmacro MUI_DEFAULT MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-branding.bmp"
!endif

!ifdef THEME_ORANGE
!ifndef APPICON
  !insertmacro MUI_DEFAULT MUI_ICON "${NSISDIR}\Contrib\Graphics\Icons\orange-install.ico"
!else
  !insertmacro MUI_DEFAULT MUI_ICON "${APPICON}"
!endif
  !insertmacro MUI_DEFAULT MUI_UNICON "${NSISDIR}\Contrib\Graphics\Icons\orange-uninstall.ico"
!ifndef APPHEADERBMP
  !define MUI_HEADERIMAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Header\orange.bmp"
!else
  !define MUI_HEADERIMAGE_BITMAP "${APPHEADERBMP}"
!endif
  !define MUI_HEADERIMAGE_UNBITMAP  "${NSISDIR}\Contrib\Graphics\Header\orange-uninstall.bmp"
!ifndef THEME_MODERN
  !insertmacro MUI_DEFAULT MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!else
  !insertmacro MUI_DEFAULT MUI_WELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\nsis3-branding.bmp"
!endif
  !insertmacro MUI_DEFAULT MUI_UNWELCOMEFINISHPAGE_BITMAP "${NSISDIR}\Contrib\Graphics\Wizard\orange.bmp"
!endif

Unicode true

  ;Default installation folder
!ifndef APPALLUSERS
!ifdef APPFOLDER
  InstallDir "$LOCALAPPDATA\${APPFOLDER}"
!else
  InstallDir "$LOCALAPPDATA\${PRODUCT_NAME}"
!endif
!else
!ifdef APPFOLDER
  InstallDir "$PROGRAMFILES\${APPFOLDER}"
!else
  InstallDir "$PROGRAMFILES\${PRODUCT_NAME}"
!endif
!endif

  ;Get installation folder from registry if available
  InstallDirRegKey ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" ""

  ;Request application privileges for Windows Vista

!ifndef APPALLUSERS
  RequestExecutionLevel user
!else
  RequestExecutionLevel admin
!endif

  
  !define ARP "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

;--------------------------------
;Variables

  Var STARTMENU_FOLDER
  Var MUI_TEMP

;--------------------------------
;Interface Settings

  !define MUI_ABORTWARNING
  !define MUI_LANGDLL_ALLLANGUAGES  
  !define MUI_HEADERIMAGE
!ifndef MUI_HEADERIMAGE_BITMAP
  !define MUI_HEADERIMAGE_BITMAP "header.bmp"
  !define MUI_HEADERIMAGE_UNBITMAP  "header-uninstall.bmp"
  !insertmacro MUI_DEFAULT MUI_WELCOMEFINISHPAGE_BITMAP "wizard.bmp"
  !insertmacro MUI_DEFAULT MUI_UNWELCOMEFINISHPAGE_BITMAP "wizard.bmp"
!ifndef APPICON
  !insertmacro MUI_DEFAULT MUI_ICON "install.ico"
!else
  !insertmacro MUI_DEFAULT MUI_ICON "${APPICON}"
!endif
  !insertmacro MUI_DEFAULT MUI_UNICON "uninstall.ico"
!endif

;--------------------------------
;Language Selection Dialog Settings

  ;The language stored in the registry will be selected by default.
  !define MUI_LANGDLL_ALWAYSSHOW

  ;Remember the installer language
  !define MUI_LANGDLL_REGISTRY_ROOT "${HKKEY}" 
  !define MUI_LANGDLL_REGISTRY_KEY "SOFTWARE\${PRODUCT_NAME}" 
  !define MUI_LANGDLL_REGISTRY_VALUENAME "Installer Language"

;--------------------------------
;Pages

  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "${HKKEY}" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "SOFTWARE\${PRODUCT_NAME}"
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
!ifdef APPFOLDER
  !define MUI_STARTMENUPAGE_DEFAULTFOLDER "${APPFOLDER}"
!endif

  !insertmacro MUI_PAGE_WELCOME
!ifdef FASTCOMP
  !insertmacro MUI_PAGE_COMPONENTS
!else
!ifdef FASTDIR
  !insertmacro MUI_PAGE_DIRECTORY
!else
!ifndef FAST
  !insertmacro MUI_PAGE_LICENSE "common\${APPLICENSE}"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
!endif
!endif
!endif
  !insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER

!ifdef APPEXTLIB
!include "custom\${PRODUCT_NAME_INTERNAL}\library.nsh"
!endif

  !insertmacro MUI_PAGE_INSTFILES
!ifndef CUSTOM
!define MUI_PAGE_CUSTOMFUNCTION_LEAVE FinishedInstall
Function FinishedInstall
ExecShell "open" "${PRODUCT_URL_VERSION}"
FunctionEnd 
!endif

!ifndef NOFINISHRUN
  !define MUI_FINISHPAGE_RUN
  !define MUI_FINISHPAGE_RUN_FUNCTION "LaunchApp"
!endif
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_COMPONENTS
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH


;--------------------------------
;Languages

;--------------------------------
;Languages

!ifndef APPLANG

!ifdef APPLANGDEFAULT
!insertmacro MUI_LANGUAGE "${APPLANGDEFAULT}"
!endif

!insertmacro MUI_LANGUAGE "English" ;first language is the default language

!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Armenian"
!insertmacro MUI_LANGUAGE "Basque"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Breton"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "Georgian"
!insertmacro MUI_LANGUAGE "German"
;!insertmacro MUI_LANGUAGE "GermanSwitzerland"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Kurdish"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Luxembourgish"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Malay"
!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "SpanishInternational"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Tatar"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Uzbek"
!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_LANGUAGE "Welsh"

!else

!insertmacro MUI_LANGUAGE "${APPLANG}"

!ifdef APPLANG2
!insertmacro MUI_LANGUAGE "${APPLANG2}"
!endif
!ifdef APPLANG3
!insertmacro MUI_LANGUAGE "${APPLANG3}"
!endif
!ifdef APPLANG4
!insertmacro MUI_LANGUAGE "${APPLANG4}"
!endif
!ifdef APPLANG5
!insertmacro MUI_LANGUAGE "${APPLANG5}"
!endif


!endif

;--------------------------------
;VersionInfo

!ifdef PRODUCT_VERSONFULL
  VIProductVersion "${PRODUCT_VERSON}"
!else
  VIProductVersion "${PRODUCT_VERSON}.${PRODUCT_VERSON_BUILD}"
!endif
!ifdef BUILD_ID
  VIAddVersionKey "Comments" "${BUILD_ID}"
!endif
  VIAddVersionKey "CompanyName" "${PRODUCT_COMPANY}"
  VIAddVersionKey "FileDescription" "${PRODUCT_NAME} Installer"
  VIAddVersionKey "FileVersion" "${PRODUCT_VERSON}"
  VIAddVersionKey "InternalName" "${FILE_NAME}-${PRODUCT_VERSON}"
!ifdef CUSTOM
  VIAddVersionKey "LegalCopyright" "Copyright © ${CurrentYear}. All rights reserved."
!else
  VIAddVersionKey "LegalCopyright" "Copyright © 2011-${CurrentYear}, MicroSIP (www.microsip.org). All rights reserved."
!endif
  VIAddVersionKey "OriginalFilename" "${FILE_NAME}-${PRODUCT_VERSON}.exe"
  VIAddVersionKey "ProductName" "${PRODUCT_NAME}"
  VIAddVersionKey "ProductVersion" "${PRODUCT_VERSON}"

;--------------------------------
; Init

!ifdef APPLITE
	!ifdef CUSTOM
		!define EXEFILE "lite\custom\${FILE_NAME}.exe"
	!else
		!define EXEFILE "lite\${FILE_NAME}.exe"	
	!endif
!else
	!ifdef CUSTOM
		!define EXEFILE "full\custom\${FILE_NAME}.exe"
	!else
		!define EXEFILE "full\${FILE_NAME}.exe"	
	!endif
!endif

!define FileCopy `!insertmacro FileCopy`
!macro FileCopy FilePath TargetDir
  CreateDirectory `${TargetDir}`
  CopyFiles `${FilePath}` `${TargetDir}`
!macroend

!macro ClearInstallUninstall

!ifdef APPALLUSERS
  SetShellVarContext all
!endif
  Delete "$DESKTOP\${PRODUCT_NAME}.lnk"
  Delete "$SMSTARTUP\${PRODUCT_NAME}.lnk"
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}"
  ReadRegStr $0 ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" ""
  DeleteRegValue HKCU "SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0\${FILE_NAME}.exe.FriendlyAppName"
  DeleteRegValue HKCU "SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\Shell\MuiCache" "$0\${FILE_NAME}.exe.ApplicationCompany"
!macroend

;--------------------------------
;Reserve Files
  
  ;If you are using solid compression, files that are required before
  ;the actual installation should be stored first in the data block,
  ;because this will make your installer start faster.
  
  !insertmacro MUI_RESERVEFILE_LANGDLL

;--------------------------------
Name "${PRODUCT_NAME}"

!ifdef INNER
  !echo "Inner invocation"                  ; just to see what's going on
  OutFile "$%TEMP%\tempinstaller.exe"       ; not really important where this is
  SetCompress off                           ; for speed
!else

!ifndef CUSTOM
!ifdef APPLITE
  !define OUTFILE "out\${FILE_NAME}-Lite-${PRODUCT_VERSON}"
!else
  !define OUTFILE "out\${FILE_NAME}-${PRODUCT_VERSON}"
!endif
!else
  !define OUTFILE "out\${FILE_NAME}-${PRODUCT_VERSON}"
!endif

OutFile "${OUTFILE}.exe"

!ifdef APPSIGN
  !echo "Outer invocation"

  ; Call makensis again, defining INNER.  This writes an installer for us which, when
  ; it is invoked, will just write the uninstaller to some location, and then exit.
  ; Be sure to substitute the name of this script here.
 
  !system "$\"${NSISDIR}\makensis$\" /DINNER installer.nsi" = 0
 
  ; So now run that installer we just created as %TEMP%\tempinstaller.exe.  Since it
  ; calls quit the return value isn't zero.
 
  !system "$%TEMP%\tempinstaller.exe" = 2
 
  ; That will have written an uninstaller binary for us.  Now we sign it with your
  ; favourite code signing tool.

!ifndef APPSIGNNAME
!define APPSIGNNAME "${FILE_NAME}"
!endif

  !system 'sign.bat "certs/${APPSIGNNAME}.pfx" "${APPSIGN}" "$%TEMP%\Uninstall.exe"' = 0
  !system `sign.bat "certs/${APPSIGNNAME}.pfx" "${APPSIGN}" "${EXEFILE}"` = 0
  !finalize `sign.bat "certs/${APPSIGNNAME}.pfx" "${APPSIGN}" "${OUTFILE}.exe"` = 0

!endif

!ifmacrodef ActFinalize
!insertmacro ActFinalize
!endif
 
!endif

;--------------------------------
;Installer Sections

Section "${PRODUCT_NAME} (required)" SecInstall

  SectionIn RO

  Push "${PRODUCT_NAME}"
  Call .closeProgram

  SetOutPath "$INSTDIR"
  
;setup ini file
  IfFileExists "$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.ini" SkipIni 0
  Rename "$APPDATA\${PRODUCT_NAME}\${PRODUCT_NAME}.ini" "$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.ini"
  IfFileExists "$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.ini" SkipIni 0
!ifdef MOVE_PRODUCT_NAME
  Rename "$APPDATA\${MOVE_PRODUCT_NAME}\${MOVE_PRODUCT_NAME}.ini" "$APPDATA\${MOVE_PRODUCT_NAME}\${MOVE_FILE_NAME}.ini"
  Rename "$APPDATA\${MOVE_PRODUCT_NAME}\${MOVE_FILE_NAME}.ini" "$APPDATA\${MOVE_PRODUCT_NAME}\${FILE_NAME}.ini"
  Rename "$APPDATA\${MOVE_PRODUCT_NAME}" "$APPDATA\${PRODUCT_NAME}"
!endif

!ifdef CUSTOM
  CreateDirectory "$APPDATA\${PRODUCT_NAME}"
  IfFileExists "$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.ini" +2 0
  File /nonfatal "/oname=$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.ini" "custom\${FILE_NAME}.ini"
!endif

SkipIni:

!ifdef APPEXTINSTALL
!include "custom\${PRODUCT_NAME_INTERNAL}\install.nsh"
!endif

!insertmacro ClearInstallUninstall

  SetShellVarContext current

; Delete files from old location
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\${FILE_NAME}.exe"
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\*.dll"
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\*.sample"
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\*.txt"
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\*.url"
  Delete /REBOOTOK "$APPDATA\${PRODUCT_NAME}\*.wav"
  
  Delete /REBOOTOK "$INSTDIR\${PRODUCT_NAME}.exe"

  File "${EXEFILE}"
!ifndef APPLITE
  File "full\*.dll"
!else
  Delete /REBOOTOK "$INSTDIR\*.dll"	
!endif
  File "common\lame_enc.dll"
!ifdef CUSTOM_DLL
  File "dlls\${CUSTOM_DLL}"
!endif
!ifdef CUSTOM_FILE1
  File "${CUSTOM_FILE1}"
!endif
!ifdef CUSTOM_FILE2
  File "${CUSTOM_FILE2}"
!endif
!ifdef CUSTOM_FILE3
  File "${CUSTOM_FILE3}"
!endif
!ifdef CUSTOM_FILE4
  File "${CUSTOM_FILE4}"
!endif
!ifdef CUSTOM_FILE5
  File "${CUSTOM_FILE5}"
!endif
!ifndef NORING
  File "common\ringing.wav"
  File "${RINGTONE}"
  File "${RINGING2}"
  File "${HANGUP}"  
!endif
  File "common\msgout.wav"
  File "common\msgin.wav"
  File /oname=License.txt "common\${APPLICENSE}"
!ifndef CUSTOM
  File "common\${FILE_NAME}.url"
!endif

!ifdef APPCOPYFILE
  File "${APPCOPYFILE}"
!endif

Delete "$INSTDIR\langpack_*"

!ifndef CUSTOM
File "${PREFIX}langpack_english.txt.sample"
!endif

!ifndef APPLANG_EMBED
  
IntCmpU $LANGUAGE 1078 0 +2 +2
File "${PREFIX}langpack_afrikaans.txt"
IntCmpU $LANGUAGE 1052 0 +2 +2
File "${PREFIX}langpack_albanian.txt"
IntCmpU $LANGUAGE 1025 0 +2 +2
File "${PREFIX}langpack_arabic.txt"
IntCmpU $LANGUAGE 1067 0 +2 +2
File "${PREFIX}langpack_armenian.txt"
IntCmpU $LANGUAGE 1069 0 +2 +2
File "${PREFIX}langpack_basque.txt"
IntCmpU $LANGUAGE 1059 0 +2 +2
File "${PREFIX}langpack_belarusian.txt"
IntCmpU $LANGUAGE 5146 0 +2 +2
File "${PREFIX}langpack_bosnian.txt"
IntCmpU $LANGUAGE 1150 0 +2 +2
File "${PREFIX}langpack_breton.txt"
IntCmpU $LANGUAGE 1026 0 +2 +2
File "${PREFIX}langpack_bulgarian.txt"
IntCmpU $LANGUAGE 1027 0 +2 +2
File "${PREFIX}langpack_catalan.txt"
IntCmpU $LANGUAGE 1050 0 +2 +2
File "${PREFIX}langpack_croatian.txt"
IntCmpU $LANGUAGE 1029 0 +2 +2
File "${PREFIX}langpack_czech.txt"
IntCmpU $LANGUAGE 1030 0 +2 +2
File "${PREFIX}langpack_danish.txt"
IntCmpU $LANGUAGE 1043 0 +2 +2
File "${PREFIX}langpack_dutch.txt"
IntCmpU $LANGUAGE 9998 0 +2 +2
File "${PREFIX}langpack_esperanto.txt"
IntCmpU $LANGUAGE 1061 0 +2 +2
File "${PREFIX}langpack_estonian.txt"
IntCmpU $LANGUAGE 1065 0 +2 +2
File "${PREFIX}langpack_farsi.txt"
IntCmpU $LANGUAGE 1035 0 +2 +2
File "${PREFIX}langpack_finnish.txt"
IntCmpU $LANGUAGE 1036 0 +2 +2
File "${PREFIX}langpack_french.txt"
IntCmpU $LANGUAGE 1110 0 +2 +2
File "${PREFIX}langpack_galician.txt"
IntCmpU $LANGUAGE 1079 0 +2 +2
File "${PREFIX}langpack_georgian.txt"
IntCmpU $LANGUAGE 1031 0 +2 +2
File "${PREFIX}langpack_german.txt"
IntCmpU $LANGUAGE 2055 0 +2 +2
File "${PREFIX}langpack_german.txt"
IntCmpU $LANGUAGE 1032 0 +2 +2
File "${PREFIX}langpack_greek.txt"
IntCmpU $LANGUAGE 1037 0 +2 +2
File "${PREFIX}langpack_hebrew.txt"
IntCmpU $LANGUAGE 1038 0 +2 +2
File "${PREFIX}langpack_hungarian.txt"
IntCmpU $LANGUAGE 15 0 +2 +2
File "${PREFIX}langpack_icelandic.txt"
IntCmpU $LANGUAGE 1057 0 +2 +2
File "${PREFIX}langpack_indonesian.txt"
IntCmpU $LANGUAGE 2108 0 +2 +2
File "${PREFIX}langpack_irish.txt"
IntCmpU $LANGUAGE 1040 0 +2 +2
File "${PREFIX}langpack_italian.txt"
IntCmpU $LANGUAGE 1041 0 +2 +2
File "${PREFIX}langpack_japanese.txt"
IntCmpU $LANGUAGE 1042 0 +2 +2
File "${PREFIX}langpack_korean.txt"
IntCmpU $LANGUAGE 9999 0 +2 +2
File "${PREFIX}langpack_kurdish.txt"
IntCmpU $LANGUAGE 1062 0 +2 +2
File "${PREFIX}langpack_latvian.txt"
IntCmpU $LANGUAGE 1063 0 +2 +2
File "${PREFIX}langpack_lithuanian.txt"
IntCmpU $LANGUAGE 4103 0 +2 +2
File "${PREFIX}langpack_luxembourgish.txt"
IntCmpU $LANGUAGE 1071 0 +2 +2
File "${PREFIX}langpack_macedonian.txt"
IntCmpU $LANGUAGE 1086 0 +2 +2
File "${PREFIX}langpack_malay.txt"
IntCmpU $LANGUAGE 1104 0 +2 +2
File "${PREFIX}langpack_mongolian.txt"
IntCmpU $LANGUAGE 1044 0 +2 +2
File "${PREFIX}langpack_norwegian.txt"
IntCmpU $LANGUAGE 2068 0 +2 +2
File "${PREFIX}langpack_norwegiannynorsk.txt"
IntCmpU $LANGUAGE 1045 0 +2 +2
File "${PREFIX}langpack_polish.txt"
IntCmpU $LANGUAGE 2070 0 +2 +2
File "${PREFIX}langpack_portuguese.txt"
IntCmpU $LANGUAGE 1046 0 +2 +2
File "${PREFIX}langpack_portuguesebr.txt"
IntCmpU $LANGUAGE 1048 0 +2 +2
File "${PREFIX}langpack_romanian.txt"
IntCmpU $LANGUAGE 1049 0 +2 +2
File "${PREFIX}langpack_russian.txt"
IntCmpU $LANGUAGE 3098 0 +2 +2
File "${PREFIX}langpack_serbian.txt"
IntCmpU $LANGUAGE 2074 0 +2 +2
File "${PREFIX}langpack_serbianlatin.txt"
IntCmpU $LANGUAGE 2052 0 +2 +2
File "${PREFIX}langpack_simpchinese.txt"
IntCmpU $LANGUAGE 1051 0 +2 +2
File "${PREFIX}langpack_slovak.txt"
IntCmpU $LANGUAGE 1060 0 +2 +2
File "${PREFIX}langpack_slovenian.txt"
IntCmpU $LANGUAGE 1034 0 +2 +2
File "${PREFIX}langpack_spanish.txt"
IntCmpU $LANGUAGE 3082 0 +2 +2
File "${PREFIX}langpack_spanishinternational.txt"
IntCmpU $LANGUAGE 1053 0 +2 +2
File "${PREFIX}langpack_swedish.txt"
IntCmpU $LANGUAGE 1092 0 +2 +2
File "${PREFIX}langpack_tatar.txt"
IntCmpU $LANGUAGE 1054 0 +2 +2
File "${PREFIX}langpack_thai.txt"
IntCmpU $LANGUAGE 1028 0 +2 +2
File "${PREFIX}langpack_tradchinese.txt"
IntCmpU $LANGUAGE 1055 0 +2 +2
File "${PREFIX}langpack_turkish.txt"
IntCmpU $LANGUAGE 1058 0 +2 +2
File "${PREFIX}langpack_ukrainian.txt"
IntCmpU $LANGUAGE 1091 0 +2 +2
File "${PREFIX}langpack_uzbek.txt"
IntCmpU $LANGUAGE 1066 0 +2 +2
File "${PREFIX}langpack_vietnamese.txt"
IntCmpU $LANGUAGE 1160 0 +2 +2
File "${PREFIX}langpack_welsh.txt"

!endif

!ifdef APPIE
  WriteRegDWORD ${HKKEY} "SOFTWARE\Microsoft\Internet Explorer\Main\FeatureControl\FEATURE_BROWSER_EMULATION" "${FILE_NAME}.exe" "11001"
!endif
  
  ;Store installation folder
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "" $INSTDIR

!ifdef APPINSTACEID
  ReadRegStr $2 ${HKKEY} "SOFTWARE\${PRODUCT_NAME}.storage" "InstanceId"
  StrCmp $2 "" 0 SkipInstanceId
  ReadRegStr $2 ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "InstanceId"
  StrCmp $2 "" 0 WriteInstanceId
badrange:
    System::Call 'advapi32::SystemFunction036(*i0r0,i1)'
    IntCmpU $0 127 "" ""  badrange ; Limit to ASCII, IsCharAlphaNumeric is locale specific
    System::Call 'user32::IsCharAlphaNumericA(ir0)i.r1'
    StrCmp $1 0 badrange
    IntFmt $0 "%c" $0
    StrCpy $2 "$2$0"
    StrLen $0 $2
    IntCmpU $0 10 "" badrange
WriteInstanceId:
  WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}.storage" "InstanceId" $2
SkipInstanceId:
!endif

;Register in default applications

;DeleteRegKey ${HKKEY} "SOFTWARE\Classes\tel"
;DeleteRegKey ${HKKEY} "SOFTWARE\Classes\callto"
;DeleteRegKey ${HKKEY} "SOFTWARE\Classes\sip"
;!ifdef CUSTOM_HANDLER
;DeleteRegKey ${HKKEY} "SOFTWARE\Classes\${CUSTOM_HANDLER}"
;!endif

WriteRegStr ${HKKEY} "SOFTWARE\Classes\tel" "" "URL:tel"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\tel" "URL Protocol" ""
WriteRegStr ${HKKEY} "SOFTWARE\Classes\callto" "" "URL:callto"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\callto" "URL Protocol" ""
WriteRegStr ${HKKEY} "SOFTWARE\Classes\sip" "" "URL:sip"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\sip" "URL Protocol" ""
WriteRegStr ${HKKEY} "SOFTWARE\Classes\dialpad" "" "URL:dialpad"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\dialpad" "URL Protocol" ""
WriteRegStr ${HKKEY} "SOFTWARE\Classes\dial" "" "URL:dial"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\dial" "URL Protocol" ""
!ifdef CUSTOM_HANDLER
WriteRegStr ${HKKEY} "SOFTWARE\Classes\${CUSTOM_HANDLER}" "" "URL:${CUSTOM_HANDLER}"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\${CUSTOM_HANDLER}" "URL Protocol" ""
!endif

WriteRegStr ${HKKEY} "SOFTWARE\Classes\${FILE_NAME}.dial" "" "Dial"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\${FILE_NAME}.dial\DefaultIcon" "" "$INSTDIR\${FILE_NAME}.exe,${FILE_ICON_INDEX}"
WriteRegStr ${HKKEY} "SOFTWARE\Classes\${FILE_NAME}.dial\shell\open\command" "" "$\"$INSTDIR\${FILE_NAME}.exe$\" $\"%1$\""
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities" "ApplicationDescription" "Softphone"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities" "ApplicationName" "${PRODUCT_NAME}"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "tel" "${FILE_NAME}.dial"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "callto" "${FILE_NAME}.dial"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "sip" "${FILE_NAME}.dial"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "dialpad" "${FILE_NAME}.dial"
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "dial" "${FILE_NAME}.dial"
!ifdef CUSTOM_HANDLER
WriteRegStr ${HKKEY} "SOFTWARE\${PRODUCT_NAME}\Capabilities\UrlAssociations" "${CUSTOM_HANDLER}" "${FILE_NAME}.dial"
!endif

WriteRegStr ${HKKEY} "SOFTWARE\RegisteredApplications" "${PRODUCT_NAME}" "SOFTWARE\${PRODUCT_NAME}\Capabilities"

;end

; reset flags
  WriteRegDWORD ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "DesktopShortcut" "0"
  WriteRegDWORD ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "RunAtSystemStartup" "0"

  ;Create uninstaller
!ifndef APPSIGN
  WriteUninstaller "$INSTDIR\Uninstall.exe"
!else
!ifndef INNER
  SetOutPath $INSTDIR
  ; this packages the signed uninstaller
  File $%TEMP%\Uninstall.exe
!endif
!endif

;write uninstall strings
  WriteRegStr ${HKKEY} "${ARP}" "DisplayIcon" "$INSTDIR\${FILE_NAME}.exe,${FILE_ICON_INDEX}"
  WriteRegStr ${HKKEY} "${ARP}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${HKKEY} "${ARP}" "DisplayVersion" "${PRODUCT_VERSON}"
!ifndef CUSTOM
  WriteRegStr ${HKKEY} "${ARP}" "HelpLink" "${PRODUCT_URL_HELP}"
  WriteRegStr ${HKKEY} "${ARP}" "URLInfoAbout" "${PRODUCT_URL_HOME}"
  WriteRegStr ${HKKEY} "${ARP}" "URLUpdateInfo" "${PRODUCT_URL_VERSION}"
!endif
  WriteRegStr ${HKKEY} "${ARP}" "Publisher" "${PRODUCT_COMPANY}"
  WriteRegDWORD ${HKKEY} "${ARP}" "NoModify" "1"
  WriteRegDWORD ${HKKEY} "${ARP}" "NoRepair" "1"
  WriteRegStr ${HKKEY} "${ARP}" "UninstallString" '"$INSTDIR\Uninstall.exe"'
  
 ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
 IntFmt $0 "0x%08X" $0
 WriteRegDWORD ${HKKEY} "${ARP}" "EstimatedSize" "$0"
 
 
 !ifdef DSCP
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS" "Application DSCP Marking Request" "Allowed"

  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Version" "1.0"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Application Name" "${FILE_NAME}.exe"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Protocol" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Local Port" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Local IP" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Local IP Prefix Length" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Remote Port" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Remote IP" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Remote IP Prefix Length" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "DSCP Value" "51"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\VoIP" "Throttle Rate" "-1"
  
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Version" "1.0"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Application Name" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Protocol" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Local Port" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Local IP" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Local IP Prefix Length" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Remote Port" "*"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Remote IP" "85.119.188.0"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Remote IP Prefix Length" "24"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "DSCP Value" "51"
  WriteRegStr ${HKKEY} "SOFTWARE\Policies\Microsoft\Windows\QoS\WebPhone" "Throttle Rate" "-1"

  !endif

  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
!ifdef APPALLUSERS
  SetShellVarContext all
!endif
    ;Create shortcuts
    CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
!ifdef APPMINIMIZED
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk" "$INSTDIR\${FILE_NAME}.exe" /minimized
!else
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk" "$INSTDIR\${FILE_NAME}.exe"
!endif    
!ifndef CUSTOM
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\License.lnk" "$INSTDIR\License.txt"
    CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME} Website.lnk" "$INSTDIR\${FILE_NAME}.url"
!endif
  SetShellVarContext current
  !insertmacro MUI_STARTMENU_WRITE_END
  
SectionEnd

!ifdef NODESKTOP
Section /o "Desktop Shortcut" SecDesktopShortCut
!else
Section "Desktop Shortcut" SecDesktopShortCut
!endif
  WriteRegDWORD ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "DesktopShortcut" "1"

!ifdef APPALLUSERS
  SetShellVarContext all
!endif
!ifdef APPMINIMIZED
    CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${FILE_NAME}.exe" /minimized
!else
    CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\${FILE_NAME}.exe"
!endif   
  SetShellVarContext current

SectionEnd

!ifndef AUTORUN
!ifndef CUSTOM
!define AUTORUN
!endif
!endif  

!ifndef NOAUTORUN
!ifdef AUTORUN
Section "Run at System Startup" SecStartupShortCut
!else
Section /o "Run at System Startup" SecStartupShortCut
!endif  
  WriteRegDWORD ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "RunAtSystemStartup" "1"
  WriteRegStr HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\Run" "${PRODUCT_NAME}" '"$INSTDIR\${FILE_NAME}.exe" /minimized'
SectionEnd
!endif

;--------------------------------
;Installer Functions

Function .onInit

!ifdef INNER
  ; If INNER is defined, then we aren't supposed to do anything except write out
  ; the installer.  This is better than processing a command line option as it means
  ; this entire code path is not present in the final (real) installer.
 
  WriteUninstaller "$%TEMP%\Uninstall.exe"
  Quit  ; just bail out quickly when running the "inner" installer
!endif

  !insertmacro MUI_LANGDLL_DISPLAY

  ReadRegDWORD $0 ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "DesktopShortcut"
  StrCmp $0 "1" 0 +2
  SectionSetFlags ${SecDesktopShortCut} ${SF_SELECTED}
  StrCmp $0 "0" 0 +2
  SectionSetFlags ${SecDesktopShortCut} 0

!ifndef NOAUTORUN
  ReadRegDWORD $0 ${HKKEY} "SOFTWARE\${PRODUCT_NAME}" "RunAtSystemStartup"
  StrCmp $0 "1" 0 +2
  SectionSetFlags ${SecStartupShortCut} ${SF_SELECTED}
  StrCmp $0 "0" 0 +2
  SectionSetFlags ${SecStartupShortCut} 0
!endif

FunctionEnd

Function .onInstSuccess
${If} ${Silent}
  Call LaunchApp
${EndIf}
FunctionEnd

Function .closeProgram
  Exch $1
  Push $0
  loop:
    FindWindow $0 $1
    IntCmp $0 0 done
      #SendMessage $0 ${WM_DESTROY} 0 0
      SendMessage $0 ${WM_CLOSE} 0 0
    Sleep 100 
    Goto loop 
  done: 
  Pop $0 
  Pop $1
FunctionEnd

Function LaunchApp
; ExecShell "" "$INSTDIR\${FILE_NAME}.exe"
; Exec '"$WINDIR\explorer.exe" "$INSTDIR\${FILE_NAME}.exe"'
;  Exec '"$WINDIR\explorer.exe" "$SMPROGRAMS\$STARTMENU_FOLDER\${PRODUCT_NAME}.lnk"'
 Exec "$INSTDIR\${FILE_NAME}.exe"
FunctionEnd

;--------------------------------
;Uninstaller Section

Section "un.${PRODUCT_NAME}" UninstallSec

  Push "${PRODUCT_NAME}"
  Call un.closeProgram

  DeleteRegKey ${HKKEY} "${ARP}"

  Delete /REBOOTOK "$INSTDIR\License.txt"
  Delete /REBOOTOK "$INSTDIR\${FILE_NAME}.exe"
  Delete /REBOOTOK "$INSTDIR\*.wav"
  Delete /REBOOTOK "$INSTDIR\*.dll"
  Delete /REBOOTOK "$INSTDIR\${FILE_NAME}_log.txt"
  Delete /REBOOTOK "$INSTDIR\${FILE_NAME}.url"
  Delete /REBOOTOK "$INSTDIR\langpack_*"
  Delete /REBOOTOK "$INSTDIR\Uninstall.exe"
  
  !insertmacro ClearInstallUninstall

  !insertmacro MUI_STARTMENU_GETFOLDER Application $MUI_TEMP
  RMDir /r /REBOOTOK "$SMPROGRAMS\$MUI_TEMP"

  SetShellVarContext current

  RMDir /r /REBOOTOK "$LOCALAPPDATA\${PRODUCT_NAME}"


;Unregister from default applications

  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\tel\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\tel"
  
  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\callto\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\callto"
  
  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\sip\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\sip"

  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\dialpad\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\dialpad"

  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\dial\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\dial"

!ifdef CUSTOM_HANDLER
  ReadRegStr $0 HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\${CUSTOM_HANDLER}\UserChoice" "Progid"
  StrCmp $0 "${FILE_NAME}.dial" 0 +2
  DeleteRegKey HKCU "SOFTWARE\Microsoft\Windows\Shell\Associations\UrlAssociations\${CUSTOM_HANDLER}"
!endif

  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_tel"
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_callto"
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_sip"
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_dialpad"
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_dial"
!ifdef CUSTOM_HANDLER
  DeleteRegValue HKCU "SOFTWARE\Microsoft\Windows\CurrentVersion\ApplicationAssociationToasts" "${FILE_NAME}.dial_${CUSTOM_HANDLER}"
!endif

  DeleteRegValue ${HKKEY} "SOFTWARE\RegisteredApplications" "${PRODUCT_NAME}"
  DeleteRegKey ${HKKEY} "SOFTWARE\${PRODUCT_NAME}"
  DeleteRegKey ${HKKEY} "SOFTWARE\Classes\${FILE_NAME}.dial"
  
;end

SectionEnd

!ifdef UNCONFIG
Section "un.Configuration" UnSecConfig
!else
Section /o "un.Configuration" UnSecConfig
!endif  

  RMDir /r /REBOOTOK "$APPDATA\${PRODUCT_NAME}"
  RMDir /r /REBOOTOK "$INSTDIR"
   
SectionEnd

;--------------------------------
;Uninstaller Functions

Function un.onInit

  !insertmacro MUI_UNGETLANGUAGE
  
FunctionEnd

Function un.closeProgram
  Exch $1
  Push $0
  loop:
    FindWindow $0 $1
    IntCmp $0 0 done
      #SendMessage $0 ${WM_DESTROY} 0 0
      SendMessage $0 ${WM_CLOSE} 0 0
    Sleep 100 
    Goto loop 
  done: 
  Pop $0 
  Pop $1
FunctionEnd

;--------------------------------
;Descriptions

  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecInstall} "${PRODUCT_NAME}"
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDesktopShortCut} "Create Desktop Shortcut"
!ifndef NOAUTORUN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartupShortCut} "Start Automatically"
!endif
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
