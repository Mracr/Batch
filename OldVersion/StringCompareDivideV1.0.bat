:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Compares which characters in two strings of equal length are different
ECHO.
ECHO [USAGE]: %~nx0  {Variate1 ^| "String1"}  {Variate2 ^| "String2"}
ECHO.
ECHO=             Variate     The name of a string variable declared with the 'SET' command
ECHO=             "String"    A string with double quotes
ECHO.
ECHO=         Default, removes leading and trailing spaces from strings, then compare them.
ECHO=         If not, please change the 'delStringLeadTrailSpaces' value NOT 1, in the script
ECHO.
ECHO=         If the string contains special characters: "^^!^^%%*^|^<^>" and so on,
ECHO=         please use ^<Variate^> to pass the string rather than ^<"String"^>
ECHO.
ECHO=         If %%ERRORLEVEL%% == 1    Task execution failure   
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET delStringLeadTrailSpaces=1
SET getStringLength=%~dp0\StringCountCharLength.bat
SET delStringleadSpace=%~dp0\StringRemoveLeadingSpace.bat
SET delStringTrailSpace=%~dp0\StringRemoveTrailingSpace.bat


IF "%~1" EQU ""                           GOTO :help
IF "%~2" EQU ""                           GOTO :help
IF "%~1" EQU "?"                          GOTO :help
IF "%~1" EQU "/?"                         GOTO :help
IF NOT EXIST "%getStringLength%"          GOTO :ERROR   
IF "%delStringLeadTrailSpaces%" EQU "1" (
    IF NOT EXIST "%delStringleadSpace%"       GOTO :ERROR    
    IF NOT EXIST "%delStringTrailSpace%"      GOTO :ERROR
)


IF "!%~1!!%~2!" EQU "" (
    SET string1=%~1
    SET string2=%~2
    CALL :CompareStringDivide string1 string2
    GOTO :END
)


IF "!%~1!!%~2!" EQU "!%~1!" (
    SET string1=!%~1!
    SET string2=%~2
    CALL :CompareStringDivide string1 string2
    GOTO :END    
)


IF "!%~1!!%~2!" EQU "!%~2!" (
    SET string1=%~1
    SET string2=!%~2!
    CALL :CompareStringDivide string1 string2
    GOTO :END
)


IF "!%~1!!%~2!" NEQ "" (
    SET string1=!%~1!
    SET string2=!%~2!
    CALL :CompareStringDivide string1 string2
    GOTO :END
)


GOTO :END





:: NOTICE:If variable value contain special characters: "`~!@#$%^&*()_+-={}[]|\;:',.?/ and so on, 
:: should use 'CMD /Q /C' before 'FOR' command to prevents character loss caused by variable expansion
::::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:CompareStringDivide
 IF "%~1" EQU ""     GOTO :ERROR
 IF "%~2" EQU ""     GOTO :ERROR
 IF "%delStringLeadTrailSpaces%" EQU "1" (
     FOR /F "delims=" %%a IN ('"%delStringleadSpace%" %~1')   DO    SET %~1=%%a
     FOR /F "delims=" %%b IN ('"%delStringleadSpace%" %~2')   DO    SET %~2=%%b
     FOR /F "delims=" %%c IN ('"%delStringTrailSpace%" %~1')  DO    SET %~1=%%c
     FOR /F "delims=" %%d IN ('"%delStringTrailSpace%" %~2')  DO    SET %~2=%%d
 )
 FOR /F "delims=" %%1 IN ('"%getStringLength%" %~1')      DO    SET str1Len=%%~1
 FOR /F "delims=" %%1 IN ('"%getStringLength%" %~2')      DO    SET str2Len=%%~1
 IF "!%~1!"     EQU "!%~2!"           GOTO :EOF
 IF "!str1Len!" EQU ""                GOTO :ERROR 
 IF "!str1Len!" NEQ "!str2Len!"       GOTO :ERROR
 SET aSpace= 
 SET cursor=^|
 SET marker=
 SET str1=!%~1!
 SET str2=!%~2!
 :loop
 IF "!%~1!!%~2!" NEQ "" (
     IF "!%~1:~0,1!" NEQ "!%~2:~0,1!" (
	 SET marker=!marker!!cursor!
     ) ELSE (
	 SET marker=!marker!!aSpace!
     )
     SET %~1=!%~1:~1!
     SET %~2=!%~2:~1!
     GOTO :loop
 )
 IF "!marker!" NEQ "" (
     ECHO A-^>!Str1!
     ECHO=-  !marker!
     ECHO B-^>!Str2!
 )
 GOTO :EOF




:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF