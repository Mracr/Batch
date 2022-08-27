:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Removes trailing space from the string
ECHO.
ECHO [USAGE]: %~nx0  {Variate1 ^| "String1"}  {Variate2 ^| "String2"}
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
IF "%string%" EQU ""                         GOTO :ERROR1


:::
::: Call Function
:::
CALL :RemoveLeadingSpace string


:::
::: Program Finish
:::
GOTO :END


::::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:RemoveTrailingSpace
 IF "%~1" EQU ""        GOTO :ERROR1
 :Loop
 IF "!%~1:~-1,1!" EQU " " (
     SET %~1=!%~1:~0,-1!
     GOTO :Loop
 )
 ECHO !%~1!
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF