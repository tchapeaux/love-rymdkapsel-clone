REM Suppose the `love` and `moon` executables are in the PATH

if exist gen_love DEL /F /Q gen_love
if not exist gen_love MKDIR gen_love

set need_lib=0

if exist "src\lib" set need_lib=1
if exist "thirdparty\lib" set need_lib=1

if %need_lib% EQU 1 (
    if not exist gen_love\lib mkdir gen_love\lib

    if exist "src\lib" xcopy .\src\lib .\gen_love\lib /E /Y

    if exist "thirdparty\lib" xcopy thirdparty\lib .\gen_love\lib /E /Y
)

if exist "res" (
    if not exist "gen_love\res" mkdir gen_love\res
    xcopy .\res .\gen_love\res /E /Y
)

cd .\src
moonc -t ..\gen_love .

cd ..\gen_love

love .\

cd ..
