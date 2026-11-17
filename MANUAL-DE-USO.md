# Manual de uso — AutoEditor Mod (milissegundos)

## 1. O que a ferramenta faz

Você entrega **uma narração** e **imagens ou vídeos cujo nome diz em que momento eles entram**. A ferramenta coloca cada um na linha do tempo no tempo certo e exporta um MP4. Tudo roda no seu computador.

## 2. Abrindo a ferramenta (Windows)

1. Tenha o **Node.js LTS** instalado (<https://nodejs.org>).
2. Dê dois cliques em **`1 Run-Windows.bat`**.
3. Na primeira vez, espere a instalação e a compilação terminarem (alguns minutos).
4. O navegador abre em `http://localhost:4000`.
5. **Não feche a janela preta** enquanto estiver editando. Para encerrar, feche-a ou use `stop.bat`.

### macOS e Linux

- **Mac com chip M1–M4:** `1 Run-macOS-Silicon.command`. **Mac Intel:** `1 Run-macOS-Intel.command`. **Linux:** `./"1 Run-Linux.sh"` no terminal.
- Se não abrir por falta de permissão: `chmod +x "1 Run-macOS-Silicon.command" "1 Run-macOS-Intel.command" "1 Run-Linux.sh"`.
- No Mac, se aparecer um aviso de segurança, clique com o botão direito no arquivo → **Abrir**.
- Nos dois sistemas, o resto funciona igual (Node.js LTS instalado, janela aberta enquanto usa o app, `Ctrl+C` para parar).

## 3. Nomeando os arquivos

O nome do arquivo é o horário em que ele **começa** na timeline.

| Nome | Início |
|------|--------|
| `0-00.png` | 0 min 0 s |
| `0-05.png` | 0 min 5 s |
| `0-03-135.mp4` | 0 min 3 s 135 ms |
| `1-20-050.png` | 1 min 20 s 50 ms |
| `1-02-05-250.png` | 1 h 02 min 05 s 250 ms |
| `1-02-05.png` | 1 h 02 min 05 s (formato original) |

Regras:

- Formato **minuto-segundo-milissegundo**: `m-ss-mmm`. O primeiro número é o minuto, o segundo são os segundos e o terceiro são **sempre 3 dígitos** de milissegundos (`050`, não `50`).
- Se o último grupo tiver **1 ou 2 dígitos**, o nome é lido como `hh-mm-ss` (como no projeto original). Por isso `0-03-50` seria 3 minutos e 50 segundos, e não 3,050 s. Escreva sempre os 3 dígitos quando quiser milissegundos.
- Pode usar `-` ou `_` como separador. A extensão e sufixos extras depois do primeiro ponto são ignorados (`0-03-135.png_2026….mp4` vale `0-03-135`).
- Imagens e vídeos funcionam. Os vídeos do MiniMax H3 podem ser nomeados com o tempo exato do corte.
- Arquivos sem tempo legível no nome aparecem como "no time" e não entram na timeline.

## 4. Criando um projeto

1. **Importe a narração** (botão ♪ na barra superior). Se enviar vários áudios, eles são unidos em uma narração só.
2. **Importe as imagens/vídeos** (botão ▦ na barra superior, ou arrastando para a tela). A bandeja mostra o tempo lido de cada arquivo, inclusive os milissegundos (ex.: `0:03.135`).
3. Abra o editor.

Como a timeline é montada:

- O que vem **antes do primeiro arquivo** fica como espaço vazio (renderiza preto).
- Cada arquivo dura **até o início do próximo**; o último vai **até o fim do áudio**.
- Arquivos com tempo **depois do fim do áudio** são ignorados, e dois arquivos no **mesmo instante** contam como duplicados (um é pulado). A ferramenta avisa quando isso acontece.

## 5. Tela do editor

```
┌───────────────┬──────────────────────────┬───────────────┐
│ Abas de edição│     Pré-visualização     │    Export     │
│ (esquerda)    │                          │   (direita)   │
├───────────────┴──────────────────────────┴───────────────┤
│                       Timeline                           │
└──────────────────────────────────────────────────────────┘
```

- **Esquerda — abas de edição:** Effects, Captions, Audio e Overlay. A divisória entre este painel e a pré-visualização pode ser arrastada (ou use as setas ← → com a divisória selecionada).
- **Centro — pré-visualização** com os controles de reprodução.
- **Direita — Export:** proporção (16:9 ou 9:16), FPS, qualidade e o botão de exportar.

### Timeline

| Faixa | O que é |
|-------|---------|
| Régua | Clique ou arraste para mover o cursor. |
| **V** | Suas imagens/vídeos. Arraste as bordas dos clipes para mudar a duração. |
| **A** | **Onda de som da narração.** Clique ou arraste para mover o cursor. |
| **FX** | Efeitos sonoros. |
| **BG** | Áudio de fundo (música). |

A onda de som mostra onde há fala e onde há pausas, o que ajuda a conferir se cada imagem entra na hora certa da narração.

## 6. Exportando

1. No painel **Export** (à direita), escolha a proporção (16:9 ou 9:16), o FPS (24, 30 ou 60) e a qualidade (Full, 720p ou 4K).
2. Confira o interruptor **Render engine**, acima do botão de render: **FFmpeg + GPU (NVENC)** (padrão) renderiza pelo servidor, usando a placa NVIDIA; **Browser (WebCodecs)** usa o encoder do navegador. Na janela preta do iniciador aparece `Video encoder: h264_nvenc (GPU / hardware)` quando a placa está sendo usada, ou `libx264 (CPU)` quando não está.
3. Inicie a exportação e acompanhe a barra de progresso.
4. O vídeo baixa pelo navegador e também é salvo automaticamente em `Downloads\AutoEditor`.

## 7. Salvando e retomando

Você pode salvar o estado do projeto em um arquivo JSON e abri-lo depois para continuar de onde parou.

## 8. Problemas comuns

| Problema | Solução |
|----------|---------|
| Erro "Falha ao compilar o app" com um caminho como `D:\#Ferramentas\...` | O caractere **`#`** no nome de uma pasta do caminho impede a compilação. Mova a pasta do projeto para um caminho sem `#` (ex.: `D:\Ferramentas\autoeditor-ms`), apague as pastas `node_modules`, `server\node_modules`, `.next` e `out`, e abra o `.bat` de novo. Evite também outros símbolos estranhos no caminho. |
| O `.bat` diz que não achou o Node | Instale o Node.js LTS e abra o `.bat` de novo. |
| Mudei o código e nada mudou | Apague a pasta `out` e abra o `.bat` de novo para recompilar. |
| O render trava no meio, ou o navegador para de usar a GPU | Deixe o interruptor **Render engine** em **FFmpeg + GPU (NVENC)** e confira, na janela preta, a linha `Video encoder`. Se aparecer `libx264 (CPU)`, atualize o driver da NVIDIA e feche outros programas que usem a placa. |
| A porta 4000 está ocupada | Rode `stop.bat` e abra o `.bat` outra vez. |
| Um arquivo aparece como "no time" | O nome não segue os formatos da seção 3. |
| A imagem entrou no tempo errado (minutos em vez de milissegundos) | Faltou completar os 3 dígitos do milissegundo (`0-03-050`). |
| A faixa A aparece vazia | O áudio não foi decodificado; importe a narração de novo (WAV ou MP3). |

## 9. Créditos e licença

Baseado no AutoEditor de Siddique (TryAIToday) e no AutoEditor Mod de banonggang. Uso pessoal e sem fins comerciais conforme o arquivo `LICENSE`. Detalhes no `README.md`.
