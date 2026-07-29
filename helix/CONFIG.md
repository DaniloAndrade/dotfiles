# Helix — Configuração do editor (`config.toml`)

Documenta cada customização em `config.toml` e o efeito real no editor,
comparado ao padrão do Helix (fonte: [documentação oficial de
configuração](https://docs.helix-editor.com/editor.html)). Linhas marcadas
como "= padrão" não mudam comportamento — estão explícitas no arquivo por
clareza, não por necessidade.

## Tema

| Opção | Valor | Efeito |
|---|---|---|
| `theme` | `"coolnight"` | Tema customizado (`themes/coolnight.toml`, neste pacote) com a mesma paleta de cores usada no WezTerm (`wezterm/.wezterm.lua`) — editor e terminal com a mesma identidade visual. |

### Paleta `coolnight`

Cores extraídas 1:1 de `wezterm/.wezterm.lua` (`config.colors`). Fundo
transparente (`ui.background` sem `bg`) para herdar o blur/opacidade já
configurados no WezTerm.

| Nome na paleta | Hex | Origem no WezTerm | Uso principal |
|---|---|---|---|
| `bg` | `#011423` | `background` | Fg do cursor e das statuslines coloridas por modo; bg fixo do bufferline (não transparente, para manter a "aba" sólida como no WezTerm); bg da linha do cursor (praticamente invisível, de propósito — ver nota abaixo) |
| `fg` | `#CBE0F0` | `foreground` | Texto padrão |
| `surface` | `#033259` | `selection_bg` | Statusline, popups, menu, seleção de texto |
| `muted` | `#214969` | `ansi[1]` (black) | Elementos de chrome sutis (borda de janela, whitespace, indent-guide) e ruler |
| `red` | `#E52E2E` | `ansi[2]` (red) | Keywords, erros |
| `green` | `#44FFB1` | `ansi[3]` (green) | Strings, hints |
| `accent_green` | `#47FF9C` | `cursor_bg` / `split` | Cursor, statusline em modo Normal |
| `yellow` | `#FFE073` | `ansi[4]` (yellow) | Funções, labels, warnings |
| `blue` | `#0FC5ED` | `ansi[5]` (blue) | Tipos, tags, statusline em modo Insert |
| `purple` | `#A277FF` | `ansi[6]` (magenta) | Constantes, keyword.control, statusline em modo Select |
| `cyan` | `#24EAF7` | `ansi[7]`/`ansi[8]` (cyan/white) | Operadores, regex, strings especiais |

Texto secundário (comentários, números de linha, inlay hints, statusline/bufferline inativos) usa `fg` com o modifier `dim` do Helix em vez de uma cor fixa — evita adicionar um 12º tom fora da paleta do WezTerm enquanto mantém contraste aceitável (o `muted` puro, a ~1.4-2:1 de contraste contra o fundo, é ilegível como cor de texto contínuo).

`ui.cursorline.primary` usa `bg` (a mesma cor do fundo) em vez de `muted`: o Helix não suporta opacidade/alpha em cores de tema, então dentro da paleta fixa não existe um tom "entre" `bg` e `muted` para sinalizar a linha atual sem competir visualmente com a seleção de texto (`surface`) — que usa uma cor bem próxima de `muted` em brilho. Deixar a linha do cursor quase transparente resolve isso: a posição do cursor continua marcada pelo número de linha relativo (destacado em `fg`) e pelo cursor em bloco (`accent_green`), e a seleção passa a ser o único destaque preenchido na tela.

Spec completa: `docs/superpowers/specs/2026-07-28-helix-coolnight-theme-design.md`.

## `[editor]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `line-number` | `"relative"` | `"absolute"` | Números de linha relativos ao cursor — essencial pra pular N linhas com contagem no modo modal (ex.: `5j`) sem precisar calcular a diferença. |
| `cursorline` | `true` | `false` | Destaca visualmente toda a linha onde está o cursor. |
| `color-modes` | `true` | `false` | O background da statusline muda de cor conforme o modo atual (Normal/Insert/Select), dando feedback visual imediato de qual modo você está. |
| `bufferline` | `"multiple"` | `"never"` | Mostra uma barra de buffers abertos no topo, mas só aparece quando há mais de um buffer — fica invisível com um único arquivo aberto. |
| `auto-format` | `true` | `true` (= padrão) | Formata o arquivo ao salvar, usando o formatter configurado por linguagem em `languages.toml`. |
| `rulers` | `[80, 120]` | `[]` (nenhuma) | Desenha guias verticais nas colunas 80 e 120, como referência visual de largura de linha. |

## `[editor.cursor-shape]`

| Modo | Valor | Efeito |
|---|---|---|
| `normal` | `"block"` | Cursor em bloco sólido no modo Normal (comportamento padrão do terminal). |
| `insert` | `"bar"` | Cursor em barra fina no modo Insert — deixa óbvio, à primeira vista, que você está digitando texto e não executando comandos. |
| `select` | `"underline"` | Cursor em sublinhado no modo Select, para diferenciar visualmente das outras duas formas. |

## `[editor.file-picker]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `hidden` | `false` | `true` | Arquivos ocultos (`.env`, `.gitignore`, etc.) passam a aparecer no file picker (`Space + f`). O padrão do Helix os esconde. |
| `git-ignore` | `true` | `true` (= padrão) | O picker continua respeitando `.gitignore`, então arquivos ignorados pelo git não poluem a lista mesmo com `hidden = false`. |

## `[editor.indent-guides]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `render` | `true` | `false` | Ativa as guias verticais de indentação (desligadas por padrão). |
| `character` | `"╎"` | `"│"` | Usa um traço mais sutil/pontilhado no lugar da barra sólida padrão, pra poluir menos visualmente. |
| `skip-levels` | `1` | `0` | Não desenha a guia do primeiro nível de indentação — reduz ruído visual em blocos de código grandes, mostrando guias só a partir do segundo nível. |

## `[editor.lsp]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `display-messages` | `true` | `true` (= padrão) | Mensagens de inicialização/status do LSP (`window/showMessage`) aparecem abaixo da statusline. |
| `display-inlay-hints` | `true` | `false` | Mostra inlay hints inline no código — por exemplo, tipos inferidos em Rust/TypeScript aparecem direto no texto, sem precisar consultar o LSP manualmente. |

## `[editor.inline-diagnostics]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `cursor-line` | `"error"` | `"disable"` | Mostra diagnósticos inline (na própria linha de código) só na linha onde o cursor está, e só para erros — warnings/hints não aparecem inline, evitando poluir a tela em arquivos com muitos avisos. Diagnósticos de outras severidades continuam visíveis pelos outros meios do Helix (gutter, lista de diagnósticos). |

## `[editor.auto-save]`

| Opção | Valor | Padrão | Efeito |
|---|---|---|---|
| `focus-lost` | `true` | `false` | Salva automaticamente o buffer ao perder o foco do Helix (ex.: trocar de painel no WezTerm). |
| `after-delay.enable` | `true` | `false` | Ativa auto-save por inatividade. |
| `after-delay.timeout` | `3000` | `3000` (= padrão) | Salva automaticamente 3 segundos depois da última edição, se o buffer ficar parado. |

## Atalhos customizados

### `[keys.normal]`

| Tecla | Ação | Efeito |
|---|---|---|
| `Ctrl-,` | `goto_previous_buffer` | Vai para o buffer aberto anterior. |
| `Ctrl-.` | `goto_next_buffer` | Vai para o próximo buffer aberto. |
| `Ctrl-d` | `half_page_down` + `goto_window_center` | Desce meia página e centraliza a linha do cursor na tela — o padrão do Helix (`page_cursor_half_down`) move cursor e viewport juntos sem centralizar, o que desorienta mais ao rolar páginas repetidamente. |
| `Ctrl-u` | `half_page_up` + `goto_window_center` | Mesma ideia para subir meia página. |
| `x` | `select_line_below` | Seleciona a linha atual; repetindo, estende/encolhe a seleção linha a linha com base no ponto onde a seleção começou. O padrão do Helix (`extend_line_below`) não preserva esse ponto de ancoragem ao encolher a seleção de volta, o que é descrito pelos próprios mantenedores como um comportamento pouco intuitivo (ver [discussão #12211](https://github.com/helix-editor/helix/discussions/12211)). |
| `X` | `select_line_above` | Mesma correção de ergonomia, para seleção linha a linha para cima. Substitui o padrão `extend_to_line_bounds`. |
| `}` | `goto_next_paragraph` | Pula para o próximo parágrafo (sem binding padrão em `{`/`}` no modo Normal). |
| `{` | `goto_prev_paragraph` | Pula para o parágrafo anterior. |

### `[keys.normal.space]` (menu `Space`)

| Tecla | Comando | Efeito |
|---|---|---|
| `x` | `:buffer-close` | Fecha o buffer atual. |
| `w` | `:write` | Salva o buffer atual. |
| `q` | `:quit` | Fecha o Helix (ou o split atual). |
| `g` | `:sh bash -c 'wezterm cli split-pane --vertical --percent 40 -- lazygit'` | Abre o `lazygit` num painel vertical do WezTerm ocupando 40% da tela, sem sair do Helix. |

### `[keys.select]`

| Tecla | Ação | Efeito |
|---|---|---|
| `}` / `{` | `goto_next_paragraph` / `goto_prev_paragraph` | Replica os atalhos de parágrafo do modo Normal, agora estendendo a seleção em vez de só mover o cursor. |
| `x` / `X` | `select_line_below` / `select_line_above` | Mesma correção de ergonomia da seleção de linha, disponível também a partir do modo Select. |

### `[keys.insert]`

| Tecla | Ação | Efeito |
|---|---|---|
| `f` seguido de `j` | `normal_mode` | Atalho `fj` para sair do modo Insert sem esticar o dedo até `Esc`. |
| `Ctrl-space` | `completion` | Dispara o autocomplete manualmente, caso ele não apareça sozinho. |
