#!/usr/bin/env bash
# AutoEditor Mod SN (milissegundos) — iniciador para Linux (Intel x86_64).
#
# (Mod: mensagens em português; a lógica é a do projeto base.)
# Starts the local render backend, which also serves the built UI on
# http://localhost:4000 and opens your browser. Mirrors the Windows start.bat.
#
# First run only: installs backend (ffmpeg) deps and builds the UI. Your
# finished videos are also auto-saved to ~/Downloads/AutoEditor.
#
# ffmpeg-static ships linux-x64 / linux-arm64 / linux-arm binaries, so the
# backend's bundled ffmpeg works on Intel AND ARM Linux out of the box.
#
# For the dev loop instead (hot-reload UI at :3000 with the backend at :4000):
#   NEXT_PUBLIC_RENDER_URL=http://localhost:4000 npm run dev   (terminal 1)
#   OPEN_BROWSER=1 node server/index.js                        (terminal 2)

set -e
cd "$(dirname "$0")"

BOLD=$'\033[1m'
DIM=$'\033[2m'
OFF=$'\033[0m'
say()  { printf "${BOLD}%s${OFF}\n" "$*"; }
info() { printf "${DIM}%s${OFF}\n" "$*"; }

# Show a native error dialog (macOS: osascript; Linux: zenity/kdialog/xmessage).
# Falls back to stderr when no GUI tool is available, so headless still works.
popup() {
  local title="$1" msg="$2" t m
  if command -v osascript >/dev/null 2>&1; then
    t=${title//\\/\\\\}; t=${t//\"/\\\"}
    m=${msg//\\/\\\\}; m=${m//\"/\\\"}; m=${m//|/$'\n'}; m=${m//$'\n'/$'\\n'}
    osascript -e "display alert \"$t\" message \"$m\" as critical buttons {\"OK\"} default button \"OK\"" >/dev/null 2>&1 && return 0
  fi
  command -v zenity   >/dev/null 2>&1 && { zenity --error --title="$title" --text="$msg" >/dev/null 2>&1 && return 0; }
  command -v kdialog  >/dev/null 2>&1 && { kdialog --title "$title" --error "$msg" >/dev/null 2>&1 && return 0; }
  command -v xmessage >/dev/null 2>&1 && { xmessage -center "$title: $msg" >/dev/null 2>&1 && return 0; }
  return 1
}
die()  { popup "AutoEditor Mod SN — Erro de início" "$*" || true; printf "Error: %s\n" "$*" >&2; exit 1; }

# O Next.js não compila se o caminho da pasta tiver o caractere # (ex.: ~/#Ferramentas).
case "$PWD" in
  *"#"*) die "O caminho desta pasta tem o caractere # e isso impede a compilação.|Mova a pasta para um caminho sem # (ex.: ~/Ferramentas/autoeditor-mod-ms), apague as pastas node_modules, server/node_modules, .next e out, e abra este arquivo de novo." ;;
esac

command -v node >/dev/null 2>&1 || die "O Node.js não está instalado. Instale pelo gerenciador de pacotes (ex.: sudo apt install nodejs, ou use o nvm) e abra este arquivo de novo."

ARCH=$(uname -m)
case "$ARCH" in
  x86_64)             SAY_ARCH="x86_64" ;;
  aarch64|arm64|armv7l) SAY_ARCH="$ARCH"
                       info "Obs.: este script é para Intel, mas o ffmpeg-static também traz"
                       info "um binário $ARCH, então deve funcionar aqui também."
                       ;;
  *) die "Arquitetura de Linux não suportada: $ARCH" ;;
esac

# On Intel, does the installed ffmpeg-static binary match this machine's arch?
# node_modules copied from another machine will have the wrong binary and fail.
FF_BIN="server/node_modules/ffmpeg-static/ffmpeg"
bin_ok() {
  case "$ARCH" in
    x86_64) : ;;
    *) return 0 ;;   # ARM: no arch-match check — the installed binary is assumed right
  esac
  command -v file >/dev/null 2>&1 || return 0
  local info status
  info=$(file "$FF_BIN" 2>/dev/null); status=$?
  [ "$status" -ne 0 ] && return 1
  echo "$info" | grep -Eq "x86[-_]64"
}

say ""
say "AutoEditor Mod SN — Linux ($SAY_ARCH)"
say "============================================================"

# 1) Backend dependencies (ffmpeg-static downloads an arch-specific binary).
if [ ! -d server/node_modules ]; then
  command -v npm >/dev/null 2>&1 || die "O npm não foi encontrado (o Node.js foi instalado sem o npm?)."
  info "Instalando as dependências do motor de render (o ffmpeg é baixado para $(uname -m))…"
  ( cd server && npm install ) || die "Falha ao instalar as dependências do motor de render.|Verifique sua internet e abra este arquivo de novo."
elif [ ! -x "$FF_BIN" ] || ! bin_ok; then
  info "O ffmpeg não existe ou é de outra arquitetura — reinstalando."
  rm -rf server/node_modules/ffmpeg-static
  ( cd server && npm install ffmpeg-static ) || die "Falha ao reinstalar o ffmpeg para o seu sistema.|Verifique sua internet e abra este arquivo de novo."
fi

# 2) Build the UI once (next build → out/). Skips when out/index.html already exists.
if [ ! -f out/index.html ]; then
  info "Compilando a interface do app (só na primeira vez, pode demorar alguns minutos)…"
  [ -d node_modules ] || npm install || die "Falha ao instalar as dependências do app.|Verifique sua internet e abra este arquivo de novo."
  npm run build || die "Falha ao compilar o app.|Veja as mensagens acima e abra este arquivo de novo."
fi

# 3) Happy-path banner, then run in the foreground. Closing this window stops it.
say ""
say "O AutoEditor Mod SN está iniciando em http://localhost:4000"
say "O navegador vai abrir sozinho. Deixe esta janela aberta."
say "Para PARAR: aperte Ctrl+C ou feche esta janela."
say "============================================================"
echo
OPEN_BROWSER=1 node server/index.js