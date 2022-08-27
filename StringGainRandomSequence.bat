:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Get a random sequence of characters
ECHO.
ECHO [USAGE]: %~nx0  ^<Type^>  ^<Length^>
ECHO.
ECHO=         Type      Character type, such as number, letter, or they combination
ECHO=                           1     only number: [0-9]*
ECHO=                           2     only lower letter: [a-z]*
ECHO=                           3     only upper letter: [A-Z]*
ECHO=                           23    only       letter: [a-zA-Z]*
ECHO=                           12    only number and lower:  [0-9a-z]*
ECHO=                           13    only number and upper:  [0-9A-Z]*
ECHO=                           123   only number and letter: [0-9a-zA-Z]*
ECHO.
ECHO=         Length    Length of characters to generate
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  Type invalid
ECHO=             2  Length invalid
ECHO=             3  Dont find script "StringCountCharLength.bat" file
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL enableDelayedExpansion


SET number=0123456789
SET lowerLetter=qwertyuiopasdfghjklzxcvbnm
SET upperLetter=QWERTYUIOPASDFGHJKLZXCVBNM
SET numberLower=0qwe1rty2uio3pas4dfg5hjk6lzx7cvb8nm9
SET numberUpper=0QWE1RTY2UIO3PAS4DFG5HJK6LZX7CVB8NM9
SET lowerUpper=QqWwEeRrTtYyUuIiOoPpAaSsDdFfGgHhJjKkLlZzXxCcVvBbNnMm
SET alphanumeric=0QqWwEe1RrTtYy2UuIiOo3PpAaSs4DdFfGg5HhJjKk6LlZzXx7CcVvBb8NnMm9
SET getStringLength=%~dp0\StringCountCharLength.bat


:::
::: Parse Command Line Argc Begin
:::
SET /A gHelp=0
SET /A gAgrc=0
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

    IF /I "!gAgrc!" EQU "0" (
	IF "%~1" NEQ ""   (
	    IF "!%~1!" NEQ "" (
        	SET type=!%~1!
	    ) ELSE (
		SET type=%~1
	    )
	    IF "%~2" NEQ ""   (
	        IF "!%~2!" NEQ "" (
        	    SET /A length=!%~2!
	        ) ELSE (
		    SET /A length=%~2
	        )
		SET /A gAgrc=1
	    ) ELSE (
	        GOTO :help
	    )
	) ELSE (
	    GOTO :help
	)
    )

) ELSE (
    SET /A Value=!gHelp! + !gAgrc!
    IF "!Value!" EQU "0"   GOTO :help
)


::: 
::: Adjust ERROR 
:::
IF "%type%" EQU ""                            GOTO :ERROR1
IF "%length%" EQU ""                          GOTO :ERROR2
IF NOT EXIST "%getStringLength%"              GOTO :ERROR3


:::
::: Call Function
:::
CALL :gainRandomSequence type length


:::
::: Program Finish
:::
GOTO :END





::::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:gainRandomSequence
 IF "%~1" EQU ""           (GOTO :ERROR1)    ELSE      SET raw=!%~1!
 IF "%~2" EQU ""           GOTO :ERROR2
 IF "!%~1!" EQU "1"        SET %~1=%number%
 IF "!%~1!" EQU "2"        SET %~1=%lowerLetter%
 IF "!%~1!" EQU "3"        SET %~1=%upperLetter%
 IF "!%~1!" EQU "12"       SET %~1=%numberLower%
 IF "!%~1!" EQU "13"       SET %~1=%numberUpper%
 IF "!%~1!" EQU "23"       SET %~1=%lowerUpper%
 IF "!%~1!" EQU "123"      SET %~1=%alphanumeric%
 IF "!%~2!" GEQ "1"        SET %~2=!%~2!
 IF "!%~1!" EQU "!raw!"    GOTO :ERROR2

 FOR /F "delims=" %%i IN ('CALL "%getStringLength%" !%~1!') DO SET /A leng=%%i
 FOR /L %%1 IN (1,1,!%~2!) DO (
     SET /A index=!random!
     FOR /F %%a IN ('SET /A index%%=!leng!') DO SET sequence=!sequence!!%~1:~%%a,1!
 )
 ECHO %sequence%
 GOTO :EOF



:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1

:ERROR2
 EXIT /B 2

:ERROR3
 EXIT /B 3


::::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF