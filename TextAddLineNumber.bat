:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
@GOTO :startWork
:help
ECHO.
ECHO [NOTICE]: Adds a line number to each line in a text file
ECHO.
ECHO [USAGE]: %~nx0  {Variate ^| "FilePath"}
ECHO.
ECHO=             Variate     The variate name of a file path that defined with the 'SET' command
ECHO=             "FilePath"  A file path with double quotes
ECHO.
ECHO=         Default, the line numbers column is right aligned to character ":"
ECHO=         if not, please modify variable 'lineNumberAlignRight' value NOT 1, in the script
ECHO.
ECHO=         If %%ERRORLEVEL%% == 1    Task execution failure   
GOTO :END
:startWork
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::




@ECHO OFF
SETLOCAL EnableDelayedExpansion


SET lineNumberAlignRight=1
SET getStringLength=%~dp0\StringCountCharLength.bat
SET getTextTotalLineCount=%~dp0\TextCountTotalLine.bat


IF "%~1" EQU ""        GOTO :help
IF "%~1" EQU "?"       GOTO :help
IF "%~1" EQU "/?"      GOTO :help


IF "%lineNumberAlignRight%" EQU "1" (
    IF NOT EXIST "%getStringLength%"            GOTO :ERROR
    IF NOT EXIST "%getTextTotalLineCount%"      GOTO :ERROR
)


IF "!%~1!" NEQ "" (
    FOR /F "delims=" %%1 IN ("!%~1!") DO     SET filePath=%%~f1
    IF NOT EXIST "!filePath!"                GOTO :ERROR
    CALL  :AddLineNumber    filePath
    GOTO :END
)


IF "!%~1!" EQU "" (
    SET filePath=%~f1
    IF NOT EXIST "!filePath!"                GOTO :ERROR
    CALL  :AddLineNumber    filePath
    GOTO :END
)


GOTO :END



:::::::::::::::::::::::::::::::::::::::::: CODE ::::::::::::::::::::::::::::::::::::::::::
:AddLineNumber
 IF "%~1" EQU ""         GOTO :ERROR
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
 IF "%~1" EQU ""              GOTO :ERROR
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
:ERROR
 EXIT /B 1


::::::::::::::::::::::::::::::::::::::::::: END ::::::::::::::::::::::::::::::::::::::::::::
:END
 GOTO :EOF