# navi

Cheatsheets do [navi](https://github.com/denisidoro/navi) para consultar as customizações e atalhos
deste próprio repositório de dotfiles.

## Estrutura

Cheats symlinkados direto no destino padrão do navi (`~/.local/share/navi/cheats/`), num
subdiretório `dotfiles/` — assim não mistura com cheatsheets de terceiros importados no futuro via
`navi repo add`. `config.yaml` fica no destino padrão também (`~/.config/navi/`).

### Por que precisa de no-folding

Diferente dos demais pacotes deste repo, este **precisa** ser stowed com `--no-folding`:

```bash
stow --no-folding navi
```

`~/.config/navi/` e `~/.local/share/navi/cheats/` não são exclusivos deste pacote — o próprio navi
escreve nesses diretórios em runtime (`navi.log`, cache) e `navi repo add` clona cheatsheets de
terceiros ali dentro. Com stow normal (tree folding), o diretório inteiro vira um symlink pro repo,
e qualquer coisa que o navi gerar depois cai fisicamente dentro do `~/dotfiles` (foi o que aconteceu
com um `navi.log` e um cheatsheet de exemplo, limpos numa sessão anterior). `--no-folding` faz o
Stow criar os diretórios intermediários de verdade no destino e symlinkar só os arquivos que este
pacote realmente possui — o resto que o navi criar ali fica fora do git, sem risco de poluir o repo.

Necessário só da primeira vez (ou depois de um `stow -D navi` seguido de restow): uma vez que
`~/.config/navi/` e `~/.local/share/navi/` existem como diretórios reais no destino, um `stow -R
navi` normal preserva a estrutura sem precisar da flag de novo.

```
navi/
├── .config/navi/config.yaml
└── .local/share/navi/cheats/dotfiles/
    ├── stow.cheat
    ├── skhd.cheat
    ├── zsh.cheat
    ├── karabiner.cheat
    ├── wezterm.cheat
    └── helix.cheat
```

`config.yaml` tem duas partes: `client.tealdeer: true` (o `tldr` instalado aqui é o `tlrc`, que só
aceita `--raw`, não mais `--markdown` — ver [issue #902](https://github.com/denisidoro/navi/issues/902))
e um bloco `style` com colunas mais estreitas de tag/comment, pensado pro painel de 30% aberto por
`Option+H` no WezTerm.

## Convenção dos `.cheat`

Tag = nome do app (`karabiner`, `skhd`, `wezterm`, `helix`, `zsh`, `stow`), sem subcategoria — tanto
pra caber no painel estreito quanto porque o bind `Option+H` do WezTerm usa o nome do processo em
foreground do pane como tag pra pré-filtrar o navi (ver `wezterm/.wezterm.lua`, tabela
`navi_tag_overrides` pra quando o binário tem nome diferente da tag, ex.: `hx` → `helix`).

Dois tipos de entrada, dependendo se o atalho documentado é um comando de shell de verdade ou só
uma referência (atalho de teclado que acontece dentro de outro app/editor):

- **Comando real** (`stow.cheat`, `skhd.cheat`, parte de `zsh.cheat`) — o corpo do cheat é o comando
  de verdade. Selecionar no navi roda (ou popula a linha, no caso do widget) o comando de fato.
- **Referência** (`karabiner.cheat`, `wezterm.cheat`, `helix.cheat`, parte de `zsh.cheat`) — o atalho
  não é executável no shell (é uma tecla dentro do Karabiner/WezTerm/Helix), então o corpo é um
  `echo "explicação"`. Selecionar no widget só imprime a resposta — inofensivo, mas devolve a
  informação na hora.

## Uso

```bash
navi                       # lista interativa (fzf)
```

Com o widget do zsh (`eval "$(navi widget zsh)"` em `zsh/.zshrc`), `Ctrl+G` abre o mesmo picker e
preenche a linha de comando com a entrada escolhida, editável antes do Enter.

`Option+H` no WezTerm abre um split de 30% à direita com o navi já filtrado pelas tags do app em
foreground no pane atual (ex.: dentro do Helix, abre já filtrado em `helix`). Sem cheats pra aquele
app, abre com o filtro vazio — dá pra apagar a query no fzf e navegar tudo normalmente.

## Manutenção

Curadoria manual, não gerada automaticamente a partir dos outros READMEs. Sempre que um atalho for
adicionado/alterado em `skhd/.skhdrc`, `karabiner/README.md`, `wezterm/KEYBINDINGS.md`,
`helix/CONFIG.md` ou nos aliases do `zsh/.zshrc`, atualize o `.cheat` correspondente na mesma
mudança — senão o catálogo do navi fica desatualizado silenciosamente.
