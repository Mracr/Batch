:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Removes all space from the string
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "String"}
ECHO.
ECHO=         Variate     The name of a string variable declared with the 'SET' command
ECHO.
ECHO=         "String"    A string with double quotes
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  String1 is NULL
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::





@ECHO OFF
SETLOCAL EnableDelayedExpansion


:::
::: Parse Command Line Argc Begin
:::
SET /A gHelp=0
SET /A eStrs=0
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

    IF /I "!eStrs!" EQU "0" (
	IF "%~1" NEQ ""   (
	    IF "!%~1!" NEQ "" (
        	SET string=!%~1!
	    ) ELSE (
		SET string=%~1
	    )
	    SET /A eStrs=1
	) ELSE (
	    GOTO :help
	)
    )
) ELSE (
    SET /A Value=!gHelp! + !eStrs!
    IF "!Value!" EQU "0"   GOTO :help
)


::: 
::: Adjust ERROR 
:::
IF "%string%" EQU ""             GOTO :ERROR1


:::
::: Call Function
:::
CALL :RemoveAllSpace string


:::
::: Program Finish
:::
GOTO :END


::::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:RemoveAllSpace
 IF   "%~1" EQU ""    GOTO :ERROR1
 SET  %~1=!%~1: =!
 ECHO !%~1!
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF