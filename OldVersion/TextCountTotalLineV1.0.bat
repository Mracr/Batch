:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Count the number of lines of content in a text file
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "FilePath"}
ECHO.
ECHO=             Variate     The variate name of a file path that defined with the 'SET' command
ECHO=             "FilePath"  A file path with double quotes
ECHO.
ECHO=         If a line has only spaces, the line is also count 
ECHO.
ECHO=         If %%ERRORLEVEL%% == 1    Task execution failure   
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


IF "%~1" EQU ""        GOTO :help
IF "%~1" EQU "?"       GOTO :help
IF "%~1" EQU "/?"      GOTO :help


IF "!%~1!" NEQ "" (
    FOR /F "delims=" %%1 IN ("!%~1!") DO     SET filePath=%%~f1
    IF NOT EXIST "!filePath!"                GOTO :ERROR
    CALL :TotalRowCount "filePath"
    GOTO :END
)


IF "!%~1!" EQU "" (
    SET filePath=%~f1
    IF NOT EXIST "!filePath!"                GOTO :ERROR
    CALL :TotalRowCount "filePath"
    GOTO :END
)


GOTO :END


:::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:TotalRowCount
 IF "%~1" EQU ""    GOTO :ERROR
 FOR /F "delims=" %%A IN ('FIND /V /C ".*" "!%~1!"') DO (
     SET string=%%A
     :loop
     IF  "!string:~-1,1!" NEQ " "  (
	     SET rowCount=!string:~-1,1!!rowCount!
	     SET string=!string:~0,-1!
	     GOTO :loop
     )
     ECHO !rowCount!
 )
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF