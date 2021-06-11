
rem This script starts VcXsrv and enable xauth shared with WSL
rem

"%ProgramFiles%\VcXsrv\vcxsrv.exe" -multiwindow -clipboard -wgl -auth "%USERPROFILE%\.Xauthority" -logfile "%USERPROFILE%\XcXsrv.log" -logverbose 5
