@echo off
set n=0 
@echo 当前目录：%cd%
@echo.

@echo ================================
@echo 列举当前目录和子目录中的"__history"文件夹
@echo --------------------------------
for /r %%i in (__history) do if exist %%i (
@echo 删除文件夹 - %%i 
rd /s/q %%i 
)
@echo.

@echo ================================
@echo 删除当前目录和子目录中的"*.dcu"文件
@echo --------------------------------
for /r %%i in (*.dcu) do if exist %%i del /s/f/q *.dcu
@echo.

@echo ================================
@echo 删除当前目录和子目录中的"*.~*"文件
@echo --------------------------------
for /r %%i in (*.~*) do if exist %%i del /s/f/q *.~*
@echo.

@echo ================================
@echo 删除当前目录和子目录中的"Thumbs.db"文件
@echo --------------------------------
for /r %%i in (Thumbs.db) do if exist %%i (
attrib %%i -s -h -r
del /s/f/q %%i
)
@echo.

pause
