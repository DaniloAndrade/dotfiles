# navi

Cheatsheets do [navi](https://github.com/denisidoro/navi) para consultar as customizações e atalhos
deste próprio repositório de dotfiles.

## Estrutura

Symlinkado direto no destino padrão do navi (`~/.local/share/navi/cheats/`), num subdiretório
`dotfiles/` — assim não mistura com cheatsheets de terceiros importados no futuro via
`navi repo add`. Sem `config.yaml`: os defaults do navi já cobrem esse caminho, sem necessidade de
`NAVI_PATH` ou `cheats.paths`.

```
navi/
└── .local/share/navi/cheats/dotfiles/
    ├── stow.cheat
    ├── skhd.cheat
    ├── zsh.cheat
    ├── karabiner.cheat
    ├── wezterm.cheat
    └── helix.cheat
```

## Convenção dos `.cheat`

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

## Manutenção

Curadoria manual, não gerada automaticamente a partir dos outros READMEs. Sempre que um atalho for
adicionado/alterado em `skhd/.skhdrc`, `karabiner/README.md`, `wezterm/KEYBINDINGS.md`,
`helix/CONFIG.md` ou nos aliases do `zsh/.zshrc`, atualize o `.cheat` correspondente na mesma
mudança — senão o catálogo do navi fica desatualizado silenciosamente.
