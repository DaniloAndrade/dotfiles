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
  gnupg
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

- **zsh** — configuração do shell (`.zshrc`)
- **wezterm** — configuração do terminal (`.wezterm.lua`)
- **helix** — configuração do editor (`config.toml`, `languages.toml`)
