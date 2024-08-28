@echo off
setlocal enabledelayedexpansion

REM Získání parametru "oddil"
set /p oddil=Zadejte nazev prave hrane  "oblasti" (napr. 05 nebo 06E) : 

REM Nastavení cest a proměnných
set cesta=%~dp0
set archiv_path=%cesta%DATA__%oddil%\ZAZN_%oddil%\%oddil%
set zazn_path=%cesta%DATA__%oddil%\ZAZN_%oddil%
set zaz_name=ZAZ_%oddil%

REM Inicializace proměnné zaz_name_length
set zaz_name_length=0

REM Výpočet délky řetězce
:calc_length
if defined zaz_name (
    set "char=!zaz_name:~%zaz_name_length%,1!"
    if not "!char!"=="" (
        set /a zaz_name_length+=1
        set "char=!zaz_name:~%zaz_name_length%,1!"
        goto :calc_length
    )
)


REM Nalezení nejnovějšího souboru v archiv_path
set newest_file=
for /f "delims=" %%f in ('dir /b /a-d /o-d "%archiv_path%\*"') do (
    set newest_file=%%f
    goto :found
)
:found

REM Pokud nebyl nalezen žádný soubor, ukončete skript
if not defined newest_file (
    echo Nenalezena zadna rozehrana partie v zadane oblasti  "%oddil%".
	pause
    exit /b
)





for /f "delims=" %%f in ('dir /b /a-d /o-d "%zazn_path%\%zaz_name%*"') do (
    set target_file=%%f
    goto :found2
)
:found2

echo  Posledni nalezena pozice je %target_file%
set  last_letter=!target_file:~%zaz_name_length%,1!
set first_letter=!target_file:~%zaz_name_length%,1!


REM Definice převodové tabulky
set "alphabet=ABCDEFGHIJKLMNOPQRSTUVWXYZ"
REM Hledání následujícího písmena


for /l %%i in (0,1,26) do (
    set "current_letter=!alphabet:~%%i,1!"
    if "!current_letter!"=="%last_letter%" (set /a "next_index=%%i + 1")
)
if %next_index% gtr 25 (set next_index=0)
set next_letter=!alphabet:~%next_index%,1!

:copyfile
REM Zkopírování nejnovějšího souboru do cílové složky
copy "%archiv_path%\%newest_file%" "%zazn_path%\ZAZ_%oddil%!next_letter!.109"
echo         Nejnovejsi stav byl ulozen jako "ZAZ_%oddil%!next_letter!.109".
endlocal
pause
