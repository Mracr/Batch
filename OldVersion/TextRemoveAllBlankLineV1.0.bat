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
 SET symbol=,.`~@#$?=_+*:;'"()[]{}abcdefghijklmnopqrstuvwxyz0123456789
 :loop
 IF "!symbol!" NEQ "" (
     SET str=
     FOR /F "delims=" %%a IN ('FINDSTR "!symbol:~0,1!" "!%~1!"') DO SET str=%%a
     IF "!str!" EQU "" (
         SET char=!symbol:~0,1! 
	 CALL :PrivateCode !char! "!filePath!"
	 GOTO :EOF
     )
     SET symbol=!symbol:~1!
     GOTO :loop
 )
 GOTO :EOF


:PrivateCode
 IF "%~1" EQU ""    GOTO :ERROR
 IF "%~2" EQU ""    GOTO :ERROR
 CMD /Q /C FOR /F "delims=%~1" %%1 IN ('TYPE "%~2"') DO ECHO %%1
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF