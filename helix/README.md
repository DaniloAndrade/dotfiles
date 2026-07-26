# Helix — LSPs, formatters e debuggers

O Helix não empacota language servers, formatters nem debuggers — ele só sabe
como invocá-los. `languages.toml` define, por linguagem, qual binário rodar;
esta página documenta o que precisa estar instalado para cada entrada
funcionar de verdade.

## Requisitos por linguagem

| Linguagem | LSP | Formatter | Debugger |
|---|---|---|---|
| rust | `rust-analyzer` | `rustfmt` | `lldb-dap` |
| go | `gopls`, `golangci-lint-langserver` | `goimports` | `dlv` |
| java | `jdtls` (+ `java-debug.jar`) | `google-java-format` | `jdtls` |
| kotlin | `kotlin-language-server` | `ktlint` | — |
| sql | `sqls` | `sql-formatter` | — |
| bash | `bash-language-server` | `shfmt` | — |
| toml | `taplo` | `taplo` | — |
| json | `vscode-json-language-server` | `prettier` | — |
| yaml | `yaml-language-server` | `prettier` | — |
| markdown | `marksman` | `prettier` | — |
| css | `vscode-css-language-server` | `prettier` | — |
| html | `vscode-html-language-server` | `prettier` | — |
| typescript / javascript | `typescript-language-server` | `prettier` | — |
| lua | `lua-language-server` | `stylua` | — |
| dockerfile | `docker-langserver` | — | — |

## Instalação

### Homebrew

```bash
brew install \
  llvm \
  jdtls \
  kotlin-language-server \
  ktlint \
  google-java-format \
  lua-language-server \
  stylua \
  marksman \
  taplo \
  shfmt \
  node
```

`llvm` é keg-only (não entra no `PATH` global) — é assim de propósito, pra não
conflitar com o clang/lldb do Xcode. O `lldb-dap` dele é resolvido em runtime
via `$(brew --prefix llvm)` num wrapper `sh -c` em `languages.toml`, sem
precisar mexer no `PATH`.

### npm (global)

```bash
npm install -g \
  bash-language-server \
  dockerfile-language-server-nodejs \
  vscode-langservers-extracted \
  yaml-language-server \
  typescript-language-server typescript \
  prettier \
  sql-formatter
```

### Go (`go install`)

```bash
go install golang.org/x/tools/gopls@latest
go install golang.org/x/tools/cmd/goimports@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install github.com/golangci/golangci-lint-langserver@latest
go install github.com/lighttiger2505/sqls@latest
```

Precisa de `$(go env GOPATH)/bin` no `PATH` — já configurado em
`zsh/.zshrc` (`export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"`).

### Rust (via rustup)

```bash
rustup component add rust-analyzer rustfmt
```

### Debugger do Java (`java-debug.jar`)

O `jdtls` carrega esse jar como javaagent para habilitar debug (attach). Ele
não vem pronto — precisa ser clonado e buildado localmente:

```bash
git clone git@github.com:microsoft/java-debug ~/.config/helix/java-debug
cd ~/.config/helix/java-debug
./mvnw clean install
cp com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar \
   ~/.config/helix/java-debug.jar
```

`~/.config/helix/java-debug/` e `java-debug.jar` são artefatos de build —
ficam fora do controle de versão deste repo (ver
`docs/superpowers/specs/2026-07-26-helix-dotfiles-design.md`).

## Verificação

Depois de instalar, confirme que tudo resolve:

```bash
hx --health
```

Para o detalhe de uma linguagem específica (LSP, debugger e formatter
configurados, com o caminho do binário resolvido):

```bash
hx --health rust
hx --health java
hx --health go
```

Qualquer linha com `✘` indica um binário que falta ou não está no `PATH`.
