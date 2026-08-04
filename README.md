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
  navi
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

**Exceção:** o pacote `navi` precisa de `stow --no-folding navi` em vez de `stow navi` (não entra no
`stow */` acima) — veja o motivo em [navi/README.md](navi/README.md#por-que-precisa-de-no-folding).

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
- **navi** — cheatsheets do [navi](https://github.com/denisidoro/navi) para consultar os atalhos e customizações deste repositório (`navi` ou `Ctrl+G` no shell). Veja [navi/README.md](navi/README.md) para a convenção dos `.cheat` e como mantê-los atualizados
