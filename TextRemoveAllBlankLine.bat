:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Remove all space line in a text file
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "FilePath"}
ECHO.
ECHO=         Variate     The variate name of a file path that defined with the 'SET' command
ECHO.
ECHO=         "FilePath"  A file path with double quotes
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  "filePath" is NULL
ECHO=             2  file NOT Exist
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


:::
::: Parse Command Line Argc Begin
:::
SET /A gHelp=0
SET /A gPath=0
:ParseCommandLine
IF "%~1" NEQ "" (
    IF /I "!gHelp!" EQU "0" (
        IF /I "%~1" EQU "?"          SET /A gHelp=1
        IF /I "%~1" EQU "/"          SET /A gHelp=1
        IF /I "%~1" EQU "-"          SET /A gHelp=1
        IF /I "%~1" EQU "/?"         SET /A gHelp=1
        IF /I "%~1" EQU "-?"         SET /A gHelp=1
        IF /I "%~1" EQU "-h"         SET /A gHelp=1
        IF /I "%~1" EQU "/h"         SET /A gHelp=1
        IF /I "!gHelp!" EQU "1"      GOTO :help
    )

    IF /I "!gPath!" EQU "0" (
	IF "%~1" NEQ ""   (
	    IF "!%~1!" NEQ "" (
        	SET filePath=!%~1!
	    ) ELSE (
		SET filePath=%~1
	    )
	    SET /A gPath=1
	) ELSE (
	    GOTO :help
	)
    )
) ELSE (
    SET /A Value=!gHelp! + !gPath!
    IF "!Value!" EQU "0"   GOTO :help
)


::: 
::: Adjust ERROR 
:::
IF "%filePath%" EQU ""                 GOTO :ERROR1
IF NOT EXIST "!filePath!"              GOTO :ERROR2  



:::
::: Call Function
:::
CALL :RemoveAllBlankLine filePath


:::
::: Program Finish
:::
GOTO :END




::"CALL" command need transmit "!Variable!" value rather than "Variable" name in CODE segemt,such as CALL :PrivateCode !char! "!filePath!"
:::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:RemoveAllBlankLine
 IF "%~1" EQU ""    GOTO :ERROR1
 FOR /F "delims=" %%i IN ('TYPE "!%~1!"') DO (
     SET str=%%i
     SET str=!str: =!
     IF "!str!" NEQ "" (
	 CMD /Q /C ECHO %%i
     )
 )
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1

:ERROR2
 EXIT /B 2

::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF