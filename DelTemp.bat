@echo off
set n=0 
@echo ��ǰĿ¼��%cd%
@echo.

@echo ================================
@echo �оٵ�ǰĿ¼����Ŀ¼�е�"__history"�ļ���
@echo --------------------------------
for /r %%i in (__history) do if exist %%i (
@echo ɾ���ļ��� - %%i 
rd /s/q %%i 
)
@echo.

@echo ================================
@echo ɾ����ǰĿ¼����Ŀ¼�е�"*.dcu"�ļ�
@echo --------------------------------
for /r %%i in (*.dcu) do if exist %%i del /s/f/q *.dcu
@echo.

@echo ================================
@echo ɾ����ǰĿ¼����Ŀ¼�е�"*.~*"�ļ�
@echo --------------------------------
for /r %%i in (*.~*) do if exist %%i del /s/f/q *.~*
@echo.

@echo ================================
@echo ɾ����ǰĿ¼����Ŀ¼�е�"Thumbs.db"�ļ�
@echo --------------------------------
for /r %%i in (Thumbs.db) do if exist %%i (
attrib %%i -s -h -r
del /s/f/q %%i
)
@echo.

pause
