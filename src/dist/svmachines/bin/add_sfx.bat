SETLOCAL ENABLEDELAYEDEXPANSION
set "mypath=%cd%"

for /f %%a in ('dir /b /ad') do (
	set "plat_folder=%mypath%\%%a"
	set "sfx=_%%a"

	for %%A in ("!plat_folder!"\*) do (
    		echo F|xcopy "%%A" "%mypath%\all_platform_files\%%~nA!sfx!%%~xA"
	)
)

