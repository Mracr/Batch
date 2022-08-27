:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Adds a line number to each line in a text file
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "FilePath"} [/a]
ECHO.
ECHO=         Variate     The variate name of a file path that defined with the 'SET' command
ECHO.
ECHO=         "FilePath"  A file path with double quotes
ECHO.
ECHO=         Global environment variable %%ERRORLEVEL%% indicate Task execution result
ECHO=             1  "filePath" is NULL
ECHO=             2  file NOT Exist
ECHO=             3  Dont find script "StringCountCharLength.bat" file
ECHO=             4  Dont find script "TextCountTotalLine.bat" file
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET lineNumberAlignRight=0
SET getStringLength=%~dp0\StringCountCharLength.bat
SET getTextTotalLineCount=%~dp0\TextCountTotalLine.bat


:::
::: Parse Command Line Argc Begin
:::
SET /A gHelp=0
SET /A gAlig=0
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

    IF /I "!gAlig!" EQU "0" (
        IF /I "%~1" EQU "/a"         SET /A gAlig=1
        IF /I "%~1" EQU "-a"         SET /A gAlig=1
        IF /I "!gAlig!" EQU "1"      SET /A lineNumberAlignRight=1 && SHIFT /1 && GOTO :ParseCommandLine
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

    SHIFT /1 && GOTO :ParseCommandLine
) ELSE (
    SET /A Value=!gHelp! + !gAlig! + !gPath!
    IF "!Value!" EQU "0"   GOTO :help
)


::: 
::: Adjust ERROR 
:::
IF "%filePath%" EQU ""                 GOTO :ERROR1
IF NOT EXIST "!filePath!"              GOTO :ERROR2   
IF "%lineNumberAlignRight%" EQU "1" (
    IF NOT EXIST "%getStringLength%"            GOTO :ERROR3
    IF NOT EXIST "%getTextTotalLineCount%"      GOTO :ERROR4
)


:::
::: Call Function
:::
CALL  :AddLineNumber    filePath


:::
::: Program Finish
:::
GOTO :END



:::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:AddLineNumber
 IF "%~1" EQU ""         GOTO :ERROR1
 IF "%lineNumberAlignRight%" EQU "1" (
     CALL :lineNumberAlignRight %~1
 ) ELSE (
     SET /A N=1
     FOR /F "delims=" %%i IN ('TYPE "!%~1!"') DO (
         ECHO !N!:%%i
         SET /A N+=1
     )
 )
 GOTO :EOF

:lineNumberAlignRight
 IF "%~1" EQU ""              GOTO :ERROR1
 FOR /F "delims=" %%i IN ('CALL "%getTextTotalLineCount%" "!%~1!"') DO  SET /A lineCount=%%i
 FOR /F "delims=" %%i IN ('CALL "%getStringLength%" !lineCount!')   DO  SET /A charWidth=%%i
 IF "!lineCount!" EQU "0"     GOTO :EOF
 SET /A spaceCount=!charWidth!
 SET /A step=1
 SET /A stair=1
 SET /A N=1
 FOR /F "delims=" %%i IN ('TYPE "!%~1!"') DO (
     IF "!step!" EQU "!stair!" (
         SET space=
         SET /A stair=!stair!*10
         SET /A spaceCount-=1
         FOR /L %%i IN (1,1,!spaceCount!) DO SET space= !space!
     )
     ECHO=!space!!N!:%%i
     SET /A N+=1
     SET /A step+=1
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


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF