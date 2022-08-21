:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Remove all space line in a text file
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "FilePath"}
ECHO.
ECHO=             Variate     The variate name of a file path that defined with the 'SET' command
ECHO=             "FilePath"  A file path with double quotes
ECHO.
ECHO=         Remove all lines that are only spaces
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
    CALL :RemoveAllBlankLine "filePath"
    GOTO :END
)


IF "!%~1!" EQU "" (
    SET FilePath=%~f1
    IF NOT EXIST "!FilePath!"                GOTO :ERROR
    CALL :RemoveAllBlankLine "filePath"
    GOTO :END
)


GOTO :END




::"CALL" command need transmit "!Variable!" value rather than "Variable" name in CODE segemt,such as CALL :PrivateCode !char! "!filePath!"
:::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:RemoveAllBlankLine
 IF "%~1" EQU ""    GOTO :ERROR
 FOR /F "delims=" %%i IN ('TYPE "!%~1!"') DO (
     SET str=%%i
     SET str=!str: =!
     IF "!str!" NEQ "" (
	 CMD /Q /C ECHO %%i
     )
 )
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF