# dotfiles

Meus arquivos de configuração gerenciados com [GNU Stow](https://www.gnu.org/software/stow/).

## Estrutura

Cada pacote é um subdiretório que espelha o layout a partir de `$HOME`:

```
dotfiles/
├── zsh/
│   └── .zshrc
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
├── nvim/
│   └── .config/
│       └── nvim/
│           └── init.lua
└── helix/
    └── .config/
        └── helix/
            ├── config.toml
            └── languages.toml
```

## Pré-requisitos

### Obrigatório

| Ferramenta | Instalar | Função |
|---|---|---|
| [Homebrew](https://brew.sh) | ver site | package manager (macOS) |
| [GNU Stow](https://www.gnu.org/software/stow/) | `brew install stow` | gerenciador de symlinks |
| [Nerd Font](https://www.nerdfonts.com/) | ver site | ícones no terminal (p10k + eza) |

### Instaladas via brew

```bash
brew install \
  fzf \
  zoxide \
  eza \
  bat \
  fd \
  ripgrep \
  git-delta \
  direnv \
  golang \
  neovim \
  gnupg \
  yazi \
  navi \
  zellij \
  lazygit
```

### Instaladas por outros meios

| Ferramenta | Como instalar | Função |
|---|---|---|
| [zinit](https://github.com/zdharma-continuum/zinit) | automático na primeira execução do `.zshrc` | plugin manager do zsh |
| [Powerlevel10k](https://github.com/romkatv/powerlevel10k) | via zinit (automático) | tema do prompt |
| [SDKMAN](https://sdkman.io) | `curl -s "https://get.sdkman.io" \| bash` | gerenciador de versões Java/Kotlin |

### Arquivo `~/.ripgreprc`

O ripgrep espera um arquivo de configuração em `$HOME/.ripgreprc`. Crie com:

```
--smart-case
--hidden
--glob=!.git/*
--glob=!node_modules/*
--glob=!target/*
--glob=!build/*
```

### Arquivo `~/.p10k.zsh`

Gerado pelo comando `p10k configure`. Sem ele o prompt carrega sem personalização.

---

## Instalação

Clone o repositório em `$HOME`:

```bash
git clone https://github.com/danilosandrade/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Aplique um pacote específico:

```bash
stow zsh
stow git
stow nvim
```

Aplique todos os pacotes de uma vez:

```bash
stow */
```

**Exceção:** os pacotes `navi` e `zellij` precisam de `stow --no-folding` (`stow --no-folding navi`,
`stow --no-folding zellij`) em vez do `stow */` acima — em ambos os casos o próprio app escreve em
runtime dentro do diretório que seria foldado. Pro `navi`, veja o motivo em
[navi/README.md](navi/README.md#por-que-precisa-de-no-folding). Pro `zellij`, é o plugin
`layout-manager` (`Ctrl g → o → l`) gravando layouts novos em `~/.config/zellij/layouts/` e o plugin
`configuration` (`Ctrl g → o → c`) reescrevendo `config.kdl` em runtime — com folding normal isso
cairia direto dentro do repo, e pior, o `configuration` poderia substituir o symlink do `config.kdl`
por um arquivo real, dessincronizando do repo sem aviso.

## Comandos úteis

| Comando | Descrição |
|---|---|
| `stow <pacote>` | Cria os symlinks do pacote |
| `stow -D <pacote>` | Remove os symlinks do pacote |
| `stow -R <pacote>` | Remove e recria os symlinks (restow) |
| `stow -n <pacote>` | Simula sem fazer nada (dry-run) |
| `stow -v <pacote>` | Verbose — mostra o que está sendo feito |
| `stow --target=$HOME <pacote>` | Especifica o diretório destino explicitamente |

## Adicionar novo pacote

1. Crie o subdiretório com o mesmo caminho relativo a `$HOME`:
   ```bash
   mkdir -p ~/dotfiles/tmux
   mv ~/.tmux.conf ~/dotfiles/tmux/.tmux.conf
   ```
2. Aplique com stow:
   ```bash
   cd ~/dotfiles && stow tmux
   ```

## Conteúdo atual

- **zsh** — configuração do shell (`.zshrc`). Inclui a função `hx()`: sem argumento, com `.` ou com um diretório, abre o [yazi](https://yazi-rs.github.io) como file picker visual antes de editar; com um arquivo, passa direto pro Helix
- **wezterm** — configuração do terminal (`.wezterm.lua`)
- **helix** — configuração do editor (`config.toml`, `languages.toml`). `C-e` no modo normal abre o yazi no diretório do buffer atual e abre o arquivo escolhido. Veja [helix/README.md](helix/README.md) (LSPs, formatters e debuggers) e [helix/CONFIG.md](helix/CONFIG.md) (customizações do `config.toml`)
- **karabiner** — configuração do [Karabiner-Elements](https://karabiner-elements.pqrs.org/), incluindo home row mods (`a s d f` / `j k l ;` viram cmd/option/ctrl/shift quando segurados) e Caps Lock como Esc (tap) / Hyper (hold), restritos ao teclado nativo e ao Keychron K3. Veja [karabiner/README.md](karabiner/README.md) para o mapeamento completo, o mecanismo de tap-hold usado e o profile "Nativo" (kill switch rápido)
- **skhd** — configuração do [skhd](https://github.com/asmvik/skhd) (`.skhdrc`). Binds de `hyper + letra` para abrir/focar apps (`c` Chrome, `t` WezTerm, `f` Finder, `n` Notion, `y` YouTube); window management via yabai ainda não decidido
- **aerospace** — configuração do [AeroSpace](https://nikitabobko.github.io/AeroSpace/) (`aerospace.toml`), window manager em tiles. Modificador é a Hyper key (Caps Lock segurado — ver [karabiner/README.md](karabiner/README.md)): `Hyper+H/J/K/L` foco, `Hyper+1..6` troca de workspace por contexto (`DEV`/`WEB`/`COMM`/`DOCS`/`PERSONAL`/`MONITORING`), `Hyper+Tab` volta ao workspace anterior, `Hyper+A` alterna tiles/accordion. `Hyper+W` entra no modo `window` — dentro dele, sem precisar da Hyper de novo: `H/J/K/L` move a janela, `Shift+H/J/K/L` troca de lugar com a vizinha (`swap`), `1..6` manda a janela pro workspace, `Esc` sai do modo. Regras automáticas por app (`on-window-detected`) mandam WezTerm/Sublime Text/GitKraken/Claude pra `DEV`, Chrome/YouTube pra `WEB`, Calendário pra `COMM`, Obsidian/Notion/Preview pra `DOCS`; Ajustes do Sistema e F-Secure abrem flutuando. As regras valem só pra janelas novas — janelas já abertas quando a config recarrega ficam onde estão (mova com `Hyper+W` + número). `PERSONAL` e `MONITORING` ficam vazios por enquanto. `start-at-login = false` — inicie manualmente (`aerospace` ou `open -a AeroSpace`) até validar. **Atenção**: se existir um `~/.aerospace.toml` legado, remova-o antes (o AeroSpace lê ambos `~/.aerospace.toml` e `~/.config/aerospace/aerospace.toml` e rejeita config ambígua)
- **navi** — cheatsheets do [navi](https://github.com/denisidoro/navi) para consultar os atalhos e customizações deste repositório (`navi` ou `Ctrl+G` no shell). Veja [navi/README.md](navi/README.md) para a convenção dos `.cheat` e como mantê-los atualizados
- **zellij** — configuração do [Zellij](https://zellij.dev) (`config.kdl`, tema `coolnight`, layouts). `LEADER+e` no WezTerm entra na sessão do projeto atual (ou abre o session-manager pra criar uma nova); layouts de desenvolvimento prontos pra `rust`, `go`, `java` e `web` (editor Helix + lazygit + pane de agente de IA + shell). Barra de tabs/status via plugin [zjstatus](https://github.com/dj95/zjstatus) (baixado automaticamente pelo Zellij no primeiro uso, pinado em release)
