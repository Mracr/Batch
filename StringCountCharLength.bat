:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Gets the count of characters in a string
ECHO.
ECHO [USAGE]: %~nx0  {Variate1 ^| "String1"}  {Variate2 ^| "String2"}
ECHO.
ECHO=             Variate     The name of a string variable declared with the 'SET' command
ECHO=             "String"    A string with double quotes
ECHO.
ECHO=         Default, will count the leading and trailing spaces of the string.
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


IF "%~1" EQU ""        GOTO :help
IF "%~1" EQU "?"       GOTO :help
IF "%~1" EQU "/?"      GOTO :help


IF "!%~1!" NEQ "" (
    SET string=!%~1!
    CALL :CountStringLength string
    GOTO :END
)


IF "!%~1!" EQU "" (
    SET string=%~1
    CALL :CountStringLength string
    GOTO :END
)


GOTO :END


:::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:CountStringLength
 IF "%~1" EQU ""     GOTO :ERROR
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
:ERROR
 EXIT /B 1


:::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF