# Changelog das alterações (versão com milissegundos)

Base: AutoEditor Mod (banonggang) v1.8.0, derivado do AutoEditor (Siddique / TryAIToday).

## Adicionado
- **Faixa A (onda de som)** na timeline, logo abaixo da faixa de imagens (V). Mostra a forma de onda do áudio de narração do projeto; clicar ou arrastar nela move o cursor de reprodução.
- **Milissegundos nos nomes dos arquivos:** `m-ss-mmm` (ex.: `0-03-135`) e `h-mm-ss-mmm` (ex.: `1-02-05-250`). O último grupo precisa ter exatamente 3 dígitos.
- Testes novos para o leitor de nomes (`lib/__tests__/timestamp.test.js`).
- `MANUAL-DE-USO.md` e este changelog.

## Alterado
- **Nome e versão:** o app agora se chama **AutoEditor Mod SN v1.1** (cabeçalho, título da aba do navegador e iniciadores). A numeração v1.8 era a do projeto base.
- **Layout do editor:** as abas de edição (Effects, Captions, Audio, Overlay) foram para a esquerda da pré-visualização; **Export** deixou de ser aba e virou um painel próprio à direita; a timeline ocupa a largura toda embaixo. Em telas estreitas (≤ 860 px) o layout empilhado original continua.
- A divisória arrastável (e as setas do teclado) agora redimensiona o painel da esquerda.
- O tour rápido (`QuickTour`) descreve o novo layout e ganhou um passo para o painel Export.
- Tempos com milissegundos aparecem como `0:03.135` na bandeja de importação e nas dicas da timeline.
- Iniciadores `1 Run-Windows.bat`, `1 Run-macOS-Intel.command`, `1 Run-macOS-Silicon.command` e `1 Run-Linux.sh` com mensagens em português (lógica igual à do projeto base).

- **Motor de render:** o botão **Render MP4** agora usa o **FFmpeg do servidor local** por padrão (placa NVIDIA via NVENC, quando disponível), em vez do encoder do navegador, que podia travar no meio do render. O interruptor **Render engine**, que estava escondido no código, ficou visível acima do botão e volta ao render do navegador (WebCodecs) se você quiser. A dica do interruptor foi corrigida.

## Corrigido
- Os iniciadores agora avisam, logo no começo, quando o caminho da pasta tem o caractere `#`, que faz o `next build` falhar com `ERR_INVALID_ARG_VALUE` (caminho com byte nulo).

## Mantido igual
- Nomes antigos (`0-05`, `1-02-05`, `0120`, `45` etc.) continuam sendo lidos exatamente como antes.
- `LICENSE` sem alterações.
- Android/Termux não foi alterado.
