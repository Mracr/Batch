:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Gets the count of characters in a string
ECHO.
ECHO [USAGE]: %~nx0  [/L] {Variate ^| "String"} [/s] [/t] 
ECHO.
ECHO=         /L  Calculate string length
ECHO=             Variate     The name of a string variable declared with the 'SET' command
ECHO=             "String"    A string with double quotes
ECHO.
ECHO=         /s  Remove leading spaces form these strings
ECHO.
ECHO=         /t  Remove Tariling spaces form these strings                  
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  String1 is NULL
ECHO=             2  Dont find script "StringRemoveLeadingSpace.bat" file
ECHO=             3  Dont find script "StringRemoveTrailingSpace.bat" file
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET /A delStringLeadingSpaces=0
SET /A delStringTrailingSpaces=0
SET Lib=%CD%
SET delStringleadSpace=%Lib%\StringRemoveLeadingSpace.bat
SET delStringTrailSpace=%Lib%\StringRemoveTrailingSpace.bat


:::
::: Parse Command Line Argc Begin
:::
SET /A gHelp=0
SET /A dLead=0
SET /A dTral=0
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

    IF /I "!dLead!" EQU "0" (
        IF /I "%~1" EQU "/s"         SET /A dLead=1
        IF /I "%~1" EQU "-s"         SET /A dLead=1
        IF /I "!dLead!" EQU "1"      SET /A delStringLeadingSpaces=1 && SHIFT /1 && GOTO :ParseCommandLine
    )

    IF /I "!dTral!" EQU "0" (
        IF /I "%~1" EQU "/t"         SET /A dTral=1
        IF /I "%~1" EQU "-t"         SET /A dTral=1
        IF /I "!dTral!" EQU "1"      SET /A delStringTrailingSpaces=1 && SHIFT /1 && GOTO :ParseCommandLine
    )

    IF /I "!eStrs!" EQU "0" (
        IF /I "%~1" EQU "/L"         SET /A eStrs=1
        IF /I "%~1" EQU "-L"         SET /A eStrs=1
        IF /I "!eStrs!" EQU "1" (
            IF "%~2" NEQ ""   (
	        IF "!%~2!" NEQ "" (
        	    SET string1=!%~2!
	        ) ELSE (
		    SET string1=%~2
	        )
	    ) ELSE (
	        GOTO :help
	    )
	) ELSE (
	    IF "%~1" NEQ ""   (
	        IF "!%~1!" NEQ "" (
        	    SET string1=!%~1!
	        ) ELSE (
		    SET string1=%~1
	        )
		SET /A eStrs=1
	    ) ELSE (
	        GOTO :help
	    )
	)
    )
    SHIFT /1 && GOTO :ParseCommandLine
) ELSE (
    SET /A Value=!gHelp! + !dLead! + !dTral! + !eStrs!
    IF "!Value!" EQU "0"   GOTO :help
)


IF "%string1%" EQU ""                         GOTO :ERROR1
IF "%delStringLeadingSpaces%" EQU "1" (
    IF NOT EXIST "%delStringleadSpace%"       GOTO :ERROR2
)
IF "%delStringTrailingSpaces%" EQU "1" (
    IF NOT EXIST "%delStringTrailSpace%"      GOTO :ERROR3
)



:::
::: Call Function Begin
:::
CALL :CountStringLength string1


:::
::: Program Finish
:::
GOTO :END


:::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:CountStringLength
 IF "%~1" EQU ""     GOTO :ERROR1
 IF "%delStringLeadingSpaces%" EQU "1" (
     FOR /F "delims=" %%a IN ('"%delStringleadSpace%" %~1')   DO    SET %~1=%%a
 )
 IF "%delStringTrailingSpaces%" EQU "1" (
     FOR /F "delims=" %%c IN ('"%delStringTrailSpace%" %~1')  DO    SET %~1=%%c
 )

 SET /A count=0
 SET str=!%~1!
 :loop 
 IF "!str!" NEQ "" (
     SET    str=!str:~1!
     SET /A count+=1
     GOTO   :loop
 )
 ECHO %count%
 GOTO :EOF


::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1

:ERROR2
 EXIT /B 2

:ERROR3
 EXIT /B 3


:::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF