:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Get a random sequence of characters
ECHO.
ECHO [USAGE]: %~nx0  ^<Type^>  ^<Length^>
ECHO.
ECHO=             Type      Character type, such as number, letter, or they combination
ECHO=                           1     only number: [0-9]*
ECHO=                           2     only lower letter: [a-z]*
ECHO=                           3     only upper letter: [A-Z]*
ECHO=                           23    only       letter: [a-zA-Z]*
ECHO=                           12    only number and lower:  [0-9a-z]*
ECHO=                           13    only number and upper:  [0-9A-Z]*
ECHO=                           123   only number and letter: [0-9a-zA-Z]*
ECHO=             Length    Length of characters to generate
ECHO.
ECHO=         Get this help, in console, please type %~nx0 /?
ECHO.
ECHO=         If %%ERRORLEVEL%% == 1    Task execution failure   
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


IF NOT EXIST "%getStringLength%"       GOTO :ERROR
IF "%~1" EQU ""                        GOTO :help
IF "%~2" EQU ""                        GOTO :help
IF "%~1" EQU "?"                       GOTO :help
IF "%~1" EQU "/?"                      GOTO :help


IF "!%~1!!%~2!" EQU "" (
    SET type=%~1
    SET length=%~2
    CALL :gainRandomSequence type length
    GOTO :END
)


IF "!%~1!!%~2!" EQU "!%~1!" (
    SET type=!%~1!
    SET length=%~2
    CALL :gainRandomSequence type length
    GOTO :END    
)


IF "!%~1!!%~2!" EQU "!%~2!" (
    SET type=%~1
    SET length=!%~2!
    CALL :gainRandomSequence type length
    GOTO :END
)


IF "!%~1!!%~2!" NEQ "" (
    SET type=!%~1!
    SET length=!%~2!
    CALL :gainRandomSequence type length
    GOTO :END
)


GOTO :END





::::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:gainRandomSequence
 IF "%~1" EQU ""           (GOTO :ERROR)    ELSE      SET raw=!%~1!
 IF "%~2" EQU ""           GOTO :ERROR
 IF "!%~1!" EQU "1"        SET %~1=%number%
 IF "!%~1!" EQU "2"        SET %~1=%lowerLetter%
 IF "!%~1!" EQU "3"        SET %~1=%upperLetter%
 IF "!%~1!" EQU "12"       SET %~1=%numberLower%
 IF "!%~1!" EQU "13"       SET %~1=%numberUpper%
 IF "!%~1!" EQU "23"       SET %~1=%lowerUpper%
 IF "!%~1!" EQU "123"      SET %~1=%alphanumeric%
 IF "!%~2!" GEQ "1"        SET %~2=!%~2!
 IF "!%~1!" EQU "!raw!"    GOTO :ERROR

 FOR /F "delims=" %%i IN ('CALL "%getStringLength%" !%~1!') DO SET /A leng=%%i
 FOR /L %%1 IN (1,1,!%~2!) DO (
     SET /A index=!random!
     FOR /F %%a IN ('SET /A index%%=!leng!') DO SET sequence=!sequence!!%~1:~%%a,1!
 )
 ECHO %sequence%
 GOTO :EOF



:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF