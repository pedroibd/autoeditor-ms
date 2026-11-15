@echo off
setlocal
cd /d "%~dp0"
title AutoEditor Mod - Milissegundos

REM ================================================================
REM  AutoEditor Mod (versao com milissegundos) - iniciador do Windows
REM  Base: AutoEditor (Siddique / TryAIToday) + AutoEditor Mod (banonggang)
REM  Mod: nomes de arquivo com milissegundos, forma de onda do audio,
REM       painel Exportar separado das abas de edicao.
REM ================================================================

REM O Next.js nao compila se o caminho da pasta tiver o caractere # (ex.: D:\#Ferramentas).
set "HERE=%~dp0"
if not "%HERE:#=%"=="%HERE%" (
  call :fail "O caminho desta pasta tem o caractere # e isso impede a compilacao.|Mova a pasta para um caminho sem # (ex.: D:\Ferramentas\autoeditor-mod-ms), apague as pastas node_modules, server\node_modules, .next e out, e abra este arquivo de novo."
)

REM Usa um Node portatil (runtime\node.exe) se existir; senao, o Node do sistema.
set "NODE=%~dp0runtime\node.exe"
if not exist "%NODE%" (
  set "NODE=node"
  where node >nul 2>nul
  if errorlevel 1 (
    call :fail "O Node.js nao foi encontrado neste computador.|Instale a versao LTS em https://nodejs.org e abra este arquivo de novo."
  )
)

REM Primeira vez: instala as dependencias do motor de render (server).
if not exist "server\node_modules" (
  where npm >nul 2>nul
  if errorlevel 1 (
    call :fail "O npm nao foi encontrado.|Instale o Node.js LTS em https://nodejs.org e abra este arquivo de novo."
  )
  echo Instalando as dependencias do motor de render...
  pushd server
  call npm install
  if errorlevel 1 (
    popd
    call :fail "Falha ao instalar as dependencias do motor de render.|Verifique sua internet e abra este arquivo de novo."
  )
  popd
)

REM Primeira vez: instala as dependencias do app e compila a interface (pasta "out").
REM Dica: se voce alterar o codigo, apague a pasta "out" para recompilar.
if not exist "out\index.html" (
  if not exist "node_modules" (
    where npm >nul 2>nul
    if errorlevel 1 (
      call :fail "O npm nao foi encontrado.|Instale o Node.js LTS em https://nodejs.org e abra este arquivo de novo."
    )
    echo Instalando as dependencias do app...
    call npm install
    if errorlevel 1 (
      call :fail "Falha ao instalar as dependencias do app.|Verifique sua internet e abra este arquivo de novo."
    )
  )
  echo Compilando o app ^(so na primeira vez, pode demorar alguns minutos^)...
  call npm run build
  if errorlevel 1 (
    call :fail "Falha ao compilar o app.|Veja as mensagens nesta janela e abra este arquivo de novo."
  )
)

echo.
echo ============================================================
echo   AutoEditor Mod esta iniciando em http://localhost:4000
echo   O navegador vai abrir sozinho.
echo.
echo   Para PARAR: feche esta janela ou aperte Ctrl+C.
echo   DEIXE ESTA JANELA ABERTA enquanto usa o app.
echo ============================================================
echo.

REM O servidor roda NESTA janela; ao fechar a janela, o app para.
set "OPEN_BROWSER=1"
"%NODE%" server\index.js
exit /b 0

REM ---------------------------------------------------------------
REM :fail  Mostra uma janela de erro e encerra. Use | para quebrar linhas.
REM ---------------------------------------------------------------
:fail
setlocal
set "MSG=%~1"
powershell -NoProfile -Command "$m=($env:MSG -split '\|') -join [char]10; Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show($m,'AutoEditor Mod - Erro de inicio','OK','Error') | Out-Null"
endlocal
exit 1
