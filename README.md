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
└── nvim/
    └── .config/
        └── nvim/
            └── init.lua
```

## Dependências

- [GNU Stow](https://www.gnu.org/software/stow/)

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow
```

## Instalação

Clone o repositório em `$HOME`:

```bash
git clone https://github.com/danilosandrade/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

Aplique um pacote específico:

```bash
stow zsh       # cria ~/. zshrc -> ~/dotfiles/zsh/.zshrc
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
