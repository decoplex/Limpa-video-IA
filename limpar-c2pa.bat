@echo off
chcp 65001 >nul
setlocal EnableExtensions DisableDelayedExpansion
title Limpar Content Credentials (C2PA)

echo.
echo  ===================================================
echo   Limpar Content Credentials (C2PA) - premiere-c2pa-fix
echo  ===================================================
echo.

where ffmpeg >nul 2>nul
if not errorlevel 1 goto checar_args
echo  [ERRO] FFmpeg nao encontrado.
echo.
echo  Instale uma vez abrindo o Terminal e rodando:
echo      winget install ffmpeg
echo  Depois feche e abra o Terminal de novo e tente outra vez.
echo.
pause
exit /b 1

:checar_args
if not "%~1"=="" goto inicio
echo  Como usar: arraste um ou mais videos em cima deste arquivo.
echo  Para cada video sera criada uma copia com "_limpo" no nome,
echo  na mesma pasta, sem recomprimir e sem perder qualidade.
echo.
pause
exit /b 0

:inicio
set /a OK=0
set /a FALHA=0
set /a PULADO=0

:loop
if "%~1"=="" goto fim

set "ENTRADA=%~f1"
set "SAIDA=%~dpn1_limpo%~x1"
set "NOME=%~nx1"
set "NOME_SAIDA=%~n1_limpo%~x1"
set "BASE=%~n1"
call set "FIM6=%%BASE:~-6%%"

if /i "%FIM6%"=="_limpo" goto ja_limpo
if exist "%SAIDA%" goto ja_existe

echo  Limpando: "%NOME%"
ffmpeg -hide_banner -loglevel error -n -i "%ENTRADA%" -map 0:v? -map 0:a? -c copy -map_metadata -1 -movflags +faststart "%SAIDA%"
if errorlevel 1 goto falhou
echo  [OK] "%NOME_SAIDA%"
set /a OK+=1
goto proximo

:falhou
echo  [FALHA] Nao foi possivel limpar "%NOME%"
if exist "%SAIDA%" del "%SAIDA%"
set /a FALHA+=1
goto proximo

:ja_limpo
echo  [PULADO] "%NOME%" ja e uma copia limpa.
set /a PULADO+=1
goto proximo

:ja_existe
echo  [PULADO] "%NOME_SAIDA%" ja existe.
set /a PULADO+=1
goto proximo

:proximo
shift
goto loop

:fim
echo.
echo  Pronto: %OK% limpo(s), %PULADO% pulado(s), %FALHA% com falha.
echo  Os originais nao foram alterados.
echo.
pause
