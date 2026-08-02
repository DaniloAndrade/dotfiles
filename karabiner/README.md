# karabiner

Configuração do [Karabiner-Elements](https://karabiner-elements.pqrs.org/).

## Symlink do diretório inteiro

Diferente dos demais pacotes deste repo, o Stow aqui symlinka o diretório `~/.config/karabiner`
inteiro, não os arquivos individuais. [A doc oficial](https://karabiner-elements.pqrs.org/docs/manual/misc/configuration-file-path/)
recomenda isso: se apenas o `karabiner.json` for symlinkado, o app não detecta mudanças no arquivo e
não recarrega a config automaticamente.

Depois de restaurar/recriar esse diretório em uma máquina nova, reinicie o serviço:

```bash
launchctl kickstart -k gui/$(id -u)/org.pqrs.service.agent.karabiner_console_user_server
```

A pasta `assets/complex_modifications/` também é versionada (vazio por enquanto), reservada para
regras importadas futuramente pela UI do Karabiner.

`automatic_backups/` (gerado automaticamente pelo próprio Karabiner dentro desse diretório) fica
de fora do git — ver `.gitignore` na raiz do repo.

## Profiles

- **Default profile** (`selected: true`) — profile ativo no dia a dia, contém as regras de home row
  mods abaixo.
- **Nativo** — profile vazio, sem nenhuma regra. Serve de kill switch rápido: troque pra ele pelo
  menu bar do Karabiner (ícone na barra superior → Profiles) sempre que precisar do teclado "cru",
  sem editar JSON ou entrar em Settings.

## Home row mods

Tocar rápido (`tap`) em `a s d f` / `j k l ;` envia a letra normal. Segurar (`hold`) ativa o
modificador correspondente:

| Tecla | Modificador | Tecla | Modificador |
|---|---|---|---|
| `a` | ⌘ left_command | `j` | ⇧ right_shift |
| `s` | ⌥ left_option | `k` | ⌃ right_control |
| `d` | ⌃ left_control | `l` | ⌥ right_option |
| `f` | ⇧ left_shift | `;` | ⌘ right_command |

Mão direita é o espelho da esquerda (`f`↔`j` = shift, `d`↔`k` = ctrl, `s`↔`l` = option, `a`↔`;` = cmd).

### Escopo de dispositivo

As regras só valem em teclados identificados via `device_if`:

- `is_built_in_keyboard: true` — teclado interno do MacBook.
- `vendor_id: 1452, product_id: 591, is_keyboard: true` — Keychron K3 (que em modo Mac se
  identifica com o vendor ID da Apple). Sem suporte a remapeamento próprio, então recebe as regras
  aqui.

Outros teclados externos (ex: Keychron K15 Pro) continuam com comportamento padrão, sem home row
mods.

### Mecanismo: por que não é o `lazy` + `to_if_alone` simples

A receita mais comum de home row mods (`to` com `lazy: true` + `to_if_alone`) ativa o modificador
**assim que qualquer segunda tecla é pressionada**, não importa o timing. Como `a` é letra final de
palavra frequente em português, `a` + espaço virava Cmd+Espaço (Spotlight) toda hora — e o mesmo
valeria para outros bigramas comuns (`as`, `sd`, etc).

Por isso as regras usam o padrão documentado oficialmente para esse cenário (["Change the f key to
the left shift key if held
down"](https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/to-if-held-down/)):

```json
{
    "to_if_alone": [{ "key_code": "a", "halt": true }],
    "to_if_held_down": [{ "key_code": "left_command" }],
    "to_delayed_action": { "to_if_canceled": [{ "key_code": "a" }] },
    "parameters": {
        "basic.to_if_held_down_threshold_milliseconds": 200,
        "basic.to_delayed_action_delay_milliseconds": 200
    }
}
```

Com isso, a tecla seguinte dispara imediatamente e sem modificação — o modificador só é considerado
"segurado de verdade" se a tecla de origem continuar pressionada sozinha por 200ms. Se outra tecla
interromper antes disso, a tecla de origem sai como letra literal e a interruptora nunca é afetada.

**Trade-off**: usar como modificador de verdade (ex: Cmd+C) exige segurar a tecla por ~200ms antes
de apertar a segunda tecla — não é mais instantâneo ao apertar as duas quase juntas. Ajuste os
valores de `basic.to_if_held_down_threshold_milliseconds` /
`basic.to_delayed_action_delay_milliseconds` (mantenha os dois iguais) se precisar de mais ou menos
tolerância.

### Não resolvido (conhecido, aceito)

Nenhuma mitigação nativa do Karabiner cobre 100% dos rolls entre duas home row mod keys do mesmo
lado da mão (ex: `sd` digitado muito rápido, sem espaço no meio) — é uma limitação conhecida da
técnica, não um bug desta config. Se incomodar na prática, dá pra ajustar o threshold ou adicionar
exceções manuais por bigrama.

## Caps Lock — Esc (tap) / Hyper (hold)

Tocar rápido no Caps Lock envia `escape` (útil no modo normal do Helix/Vim). Segurar por ~200ms
ativa o Hyper key (Cmd+Ctrl+Option+Shift simultâneos), pra usar em atalhos de app (ex: Raycast).
Mesmo mecanismo e escopo de dispositivo dos home row mods acima.

### Cuidado: arrays em `to`/`to_if_held_down` são sequência, não combo

A primeira versão listava as 4 modifiers como 4 entradas separadas:

```json
"to_if_held_down": [
    { "key_code": "left_shift" },
    { "key_code": "left_control" },
    { "key_code": "left_option" },
    { "key_code": "left_command" }
]
```

Isso **não** produz um hold simultâneo — arrays em `to`/`to_if_held_down` funcionam como sequência
(tipo macro: cada entrada é pressionada e solta antes da próxima). Resultado: as 4 modifiers
disparavam uma de cada vez (down/up, down/up...) em vez de ficarem todas pressionadas juntas, então
qualquer atalho ou clique feito depois não pegava o Hyper. Confirmado comparando com o log de
eventos do Keychron K15 Pro (que tem Hyper no firmware próprio): lá as 4 desciam juntas e só subiam
juntas ao soltar a tecla; no Caps Lock via Karabiner, cada uma subia sozinha logo em seguida.

A correção é combinar as modifiers em **um único evento**, usando uma tecla base + a propriedade
`modifiers` (a receita padrão da comunidade pra Caps Lock→Hyper):

```json
"to_if_held_down": [
    { "key_code": "left_shift", "modifiers": ["left_command", "left_control", "left_option"] }
]
```

Isso posta as 4 flags juntas em um único down, mantidas até soltar o Caps Lock — confirmado batendo
o log de eventos com o do K15 Pro.
