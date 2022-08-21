:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Removes all space from the string
ECHO.
ECHO [USAGE]: %~nx0  {Variate1 ^| "String1"}  {Variate2 ^| "String2"}
ECHO.
ECHO=             Variate     The name of a string variable declared with the 'SET' command
ECHO=             "String"    A string with double quotes
ECHO.
ECHO=         Remove string all spaces in within, leading and trailing.
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
    SET  VarA=!%~1!
    CALL :RemoveAllSpace VarA
    GOTO :END
)


IF "!%~1!" EQU "" (
    SET  VarB=%~1
    CALL :RemoveAllSpace VarB
    GOTO :END
)


GOTO :END


::::::::::::::::::::::::::::::::::::::::::: CODE :::::::::::::::::::::::::::::::::::::::::::
:RemoveAllSpace
 IF   "%~1" EQU ""    GOTO :ERROR
 SET  %~1=!%~1: =!
 ECHO !%~1!
 GOTO :EOF


:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF