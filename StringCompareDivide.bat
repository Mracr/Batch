:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Compares which characters in two strings of equal length are different
ECHO.
ECHO [USAGE]: %~nx0  [/c] {Variate1 ^| "String1"}  {Variate2 ^| "String2"} [/s] [/t]
ECHO.
ECHO=         /m  Compare both strings follow this switch
ECHO=             Variate     The name of a string variable defined
ECHO=             "String"    A string with double quotes
ECHO.
ECHO=         /s  Remove leading spaces form these strings
ECHO.
ECHO=         /t  Remove Tariling spaces form these strings                  
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  String1 is NULL
ECHO=             2  String2 is NULL
ECHO=             3  Dont find script "StringCountCharLength.bat" file
ECHO=             4  Dont find script "StringRemoveLeadingSpace.bat" file
ECHO=             5  Dont find script "StringRemoveTrailingSpace.bat" file
ECHO=             6  String1 length is 0
ECHO=             7  String2 length is 0
ECHO=             8  String1 length NOT equal string2 length
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET /A delStringLeadingSpaces=0
SET /A delStringTrailingSpaces=0
SET Lib=%CD%
SET getStringLength=%Lib%\StringCountCharLength.bat
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
        IF /I "%~1" EQU "/c"         SET /A eStrs=1
        IF /I "%~1" EQU "-c"         SET /A eStrs=1
        IF /I "!eStrs!" EQU "1" (
            IF "%~2" NEQ ""   (
	        IF "!%~2!" NEQ "" (
        	    SET string1=!%~2!
	        ) ELSE (
		    SET string1=%~2
	        )
	        IF "%~3" NEQ ""   (
        	    IF "!%~3!" NEQ "" (
	        	SET string2=!%~3!
	            ) ELSE (
		        SET string2=%~3
	            )
	        ) ELSE (
		    GOTO :help
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
	        IF "%~2" NEQ ""   (
        	    IF "!%~2!" NEQ "" (
	        	SET string2=!%~2!
	            ) ELSE (
		        SET string2=%~2
	            )
		    SET /A eStrs=1
	        ) ELSE (
		    GOTO :help
	        )
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


::: 
::: Adjust ERROR 
:::
IF "%string1%" EQU ""                         GOTO :ERROR1
IF "%string2%" EQU ""                         GOTO :ERROR2
IF NOT EXIST "%getStringLength%"              GOTO :ERROR3   
IF "%delStringLeadingSpaces%" EQU "1" (
    IF NOT EXIST "%delStringleadSpace%"       GOTO :ERROR4    
)
IF "%delStringTrailingSpaces%" EQU "1" (
    IF NOT EXIST "%delStringTrailSpace%"      GOTO :ERROR5
)


:::
::: Call Function
:::
CALL :CompareStringDivide string1 string2


:::
::: Program Finish
:::
GOTO :END





:: NOTICE:If variable value contain special characters: "`~!@#$%^&*()_+-={}[]|\;:',.?/ and so on, 
:: should use 'CMD /Q /C' before 'FOR' command to prevents character loss caused by variable expansion
::::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:CompareStringDivide
 IF "%~1" EQU ""     GOTO :ERROR1
 IF "%~2" EQU ""     GOTO :ERROR2
 IF "%delStringLeadingSpaces%" EQU "1" (
     FOR /F "delims=" %%a IN ('"%delStringleadSpace%" %~1')   DO    SET %~1=%%a
     FOR /F "delims=" %%b IN ('"%delStringleadSpace%" %~2')   DO    SET %~2=%%b
 )
 IF "%delStringTrailingSpaces%" EQU "1" (
     FOR /F "delims=" %%c IN ('"%delStringTrailSpace%" %~1')  DO    SET %~1=%%c
     FOR /F "delims=" %%d IN ('"%delStringTrailSpace%" %~2')  DO    SET %~2=%%d
 )

 FOR /F "delims=" %%1 IN ('"%getStringLength%" %~1')      DO    SET str1Len=%%~1
 FOR /F "delims=" %%1 IN ('"%getStringLength%" %~2')      DO    SET str2Len=%%~1

 IF "!%~1!"     EQU "!%~2!"           GOTO :EOF
 IF "!str1Len!" EQU ""                GOTO :ERROR6 
 IF "!str2Len!" EQU ""                GOTO :ERROR7 
 IF "!str1Len!" NEQ "!str2Len!"       GOTO :ERROR8

 SET aSpace= 
 SET cursor=^|
 SET marker=
 SET str1=!%~1!
 SET str2=!%~2!
 SET /A Count=0
 
 REM "Set string diff formset"
 :loop
 IF "!%~1!!%~2!" NEQ "" (
     IF "!%~1!" EQU "" GOTO :EndComp
     IF "!%~2!" EQU "" GOTO :EndComp
     IF "!%~1:~0,1!" NEQ "!%~2:~0,1!" (
	 SET marker=!marker!!cursor!
	 SET /A Count+=1
     ) ELSE (
	 SET marker=!marker!!aSpace!
     )
     SET %~1=!%~1:~1!
     SET %~2=!%~2:~1!
     GOTO :loop
 )

 FOR /F "delims=" %%1 IN ('"%getStringLength%" !Count!') DO SET Diff=%%~1

 REM "Print string diff"
 :EndComp
 IF "!marker!" NEQ "" (
     ECHO Str1-^>"!Str1!"
     ECHO=-----^> !marker!
     ECHO Str2-^>"!Str2!"
 )

 GOTO :EOF




:::::::::::::::::::::::::::::::::::::::::: ERROR ::::::::::::::::::::::::::::::::::::::::::
:ERROR1
 EXIT /B 1

:ERROR2
 EXIT /B 2

:ERROR3
 EXIT /B 3

:ERROR4
 EXIT /B 4

:ERROR5
 EXIT /B 5

:ERROR6
 EXIT /B 6

:ERROR7
 EXIT /B 7

:ERROR8
 EXIT /B 8

:ERROR9
 EXIT /B 9

:ERROR10
 EXIT /B 10


::::::::::::::::::::::::::::::::::::::::::: END :::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF