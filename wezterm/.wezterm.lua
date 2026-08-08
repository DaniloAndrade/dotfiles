local wezterm = require("wezterm")
local chord = wezterm.plugin.require("https://github.com/sravioli/chord.wz")

-- wezterm.plugin.require não tem pin nativo por URL (feature request em
-- aberto: https://github.com/wezterm/wezterm/issues/6461). No primeiro clone
-- ele baixa o HEAD do branch default; aqui fixamos manualmente na última tag
-- estável para não rodar código não revisado.
for _, plugin in ipairs(wezterm.plugin.list()) do
  if plugin.url == "https://github.com/sravioli/chord.wz" then
    wezterm.run_child_process({ "git", "-C", plugin.plugin_dir, "checkout", "--quiet", "1.1.0" })
  end
end

local config = wezterm.config_builder()

-- Colorscheme coolnight (mantido)
config.colors = {
  foreground = "#CBE0F0",
  background = "#011423",
  cursor_bg = "#47FF9C",
  cursor_border = "#47FF9C",
  cursor_fg = "#011423",
  selection_bg = "#033259",
  selection_fg = "#CBE0F0",
  ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
  brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
  split = "#47FF9C",
}

config.enable_kitty_keyboard = true
config.font_size = 19
config.window_decorations = "RESIZE"

config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10
config.window_padding = { left = 4, right = 4, top = 0, bottom = 4 }

config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.5,
}




local act = wezterm.action
-- Leader key
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
  -- Splits
  { key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" }, desc = "split horizontal" },
  { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" }, desc = "split vertical" },
  -- Navegação entre painéis
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left"), desc = "painel à esquerda" },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down"), desc = "painel abaixo" },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up"), desc = "painel acima" },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right"), desc = "painel à direita" },
  -- Ações de painel
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane { confirm = true }, desc = "fechar painel" },
  { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState, desc = "zoom no painel" },
  -- Abas
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain"), desc = "nova aba" },
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1), desc = "próxima aba" },
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1), desc = "aba anterior" },
  { key = ",", mods = "LEADER", desc = "renomear aba", action = wezterm.action.PromptInputLine {
    description = "Novo nome para a aba:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
  -- Ir para aba por número
  { key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0), desc = "aba 1" },
  { key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1), desc = "aba 2" },
  { key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2), desc = "aba 3" },
  { key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3), desc = "aba 4" },
  { key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4), desc = "aba 5" },
  { key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5), desc = "aba 6" },
  { key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6), desc = "aba 7" },
  { key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7), desc = "aba 8" },
  { key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8), desc = "aba 9" },
  -- Workspaces
  { key = "S", mods = "LEADER", desc = "novo workspace", action = wezterm.action.PromptInputLine {
    description = "Nome do novo workspace:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:perform_action(
          wezterm.action.SwitchToWorkspace { name = line },
          pane
        )
      end
    end),
  }},
  { key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" }, desc = "listar workspaces" },
  { key = "Tab", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(-1), desc = "trocar workspace" },
  { key = "R", mods = "LEADER", desc = "renomear workspace", action = wezterm.action.PromptInputLine {
    description = "Renomear workspace:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        wezterm.mux.rename_workspace(window:active_workspace(), line)
      end
    end),
  }},

  -- Zellij: entra na sessão do projeto atual (nome = pasta do cwd) se ela já
  -- existir; senão cai no session-manager nativo do Zellij (welcome screen),
  -- que deixa escolher nome/layout/folder da nova sessão. SendString em vez de
  -- spawnar processo via API do WezTerm: mantém o toggle "na aba atual" — sair
  -- do Zellij (detach/quit, ver navi zellij.cheat) devolve a aba pro shell puro
  -- sem precisar de nenhum bind de volta.
  {
    key = "e",
    mods = "LEADER",
    desc = "zellij: attach na sessão do projeto (ou session-manager)",
    action = wezterm.action_callback(function(window, pane)
      local cwd_uri = pane:get_current_working_dir()
      local cwd = cwd_uri and cwd_uri.file_path or os.getenv("HOME")
      local project = cwd:gsub("/$", ""):match("([^/]+)$") or "zellij"
      local escaped_project = project:gsub("([\\\"$`])", "\\%1")
      window:perform_action(
        act.SendString('zellij attach "' .. escaped_project .. '" 2>/dev/null || zellij --layout welcome\n'),
        pane
      )
    end),
  },

  -- Abre o navi filtrado pelo app em foreground do pane atual. Tag do navi
  -- normalmente é o próprio nome do processo (ex: "zsh"); só precisa de
  -- override aqui quando o binário tem nome diferente da tag usada nos
  -- .cheat (navi/README.md documenta as tags). Sem match, abre sem filtro.
  -- ALT+SHIFT (não só ALT): Alt+h sozinho é o bind nativo do Zellij pra
  -- navegar pra pane/aba à esquerda (MoveFocusOrTab) — como o WezTerm
  -- intercepta a tecla antes dela chegar na sessão, mantê-lo em Alt puro
  -- deixaria a navegação do Zellij morta. Movido pra abrir espaço.
  {
    key = "h",
    mods = "ALT|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      local navi_tag_overrides = { hx = "helix" }
      local process = pane:get_foreground_process_name() or ""
      local app_name = process:match("([^/\\]+)$") or ""
      local query = navi_tag_overrides[app_name] or app_name

      -- Command explícito no SplitPane não passa por shell de login/interativo,
      -- então PATH fica só o mínimo do sistema (sem /opt/homebrew/bin). `zsh -lic`
      -- carrega o .zshrc (onde o brew shellenv roda) antes de executar o navi.
      -- "$1" via positional arg (não concatenação) evita qualquer problema de
      -- quoting no nome do processo.
      window:perform_action(
        act.SplitPane {
          direction = "Right",
          size = { Percent = 30 },
          command = { args = { "zsh", "-lic", 'navi --query "$1"', "_", query } },
        },
        pane
      )
    end),
    desc = "navi (cheatsheets do app atual)",
  },
}

-- chord.wz: overlay de ajuda com todos os atalhos (LEADER + ?)
chord.overlay.apply(config, {
  key = "<leader>?",
  title = "Atalhos do WezTerm",
  sources = { "keys" },
})

-- Tab bar retro (mais compacto que o fancy)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.colors.tab_bar = {
  background = "#011423",
  active_tab = {
    bg_color = "#033259",
    fg_color = "#CBE0F0",
  },
  inactive_tab = {
    bg_color = "#011423",
    fg_color = "#214969",
  },
  inactive_tab_hover = {
    bg_color = "#011423",
    fg_color = "#CBE0F0",
  },
  new_tab = {
    bg_color = "#011423",
    fg_color = "#214969",
  },
  new_tab_hover = {
    bg_color = "#011423",
    fg_color = "#CBE0F0",
  },
}

-- Título da aba: nome customizado ou basename do processo
wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local title = tab.tab_title
  if title and #title > 0 then
    return title
  end
  local pane = tab.active_pane
  local process = pane.foreground_process_name
  if process and #process > 0 then
    return " " .. process:match("([^/\\]+)$") .. " "
  end
  return tab.active_pane.title
end)


-- Status: todos os workspaces à esquerda, LEADER + hora à direita
wezterm.on("update-status", function(window, pane)
  local workspaces = wezterm.mux.get_workspace_names()
  local active = window:active_workspace()

  local items = {}
  for _, name in ipairs(workspaces) do
    if name == active then
      table.insert(items, { Background = { Color = "#033259" } })
      table.insert(items, { Foreground = { Color = "#47FF9C" } })
    else
      table.insert(items, { Background = { Color = "#011423" } })
      table.insert(items, { Foreground = { Color = "#214969" } })
    end
    table.insert(items, { Text = " " .. name .. " " })
  end

  window:set_left_status(wezterm.format(items))

  local leader_indicator = ""
  if window:leader_is_active() then
    leader_indicator = wezterm.format({
      { Foreground = { Color = "#FFE073" } },
      { Text = " LEADER " },
    })
  end

  window:set_right_status(leader_indicator .. wezterm.format({
    { Foreground = { Color = "#CBE0F0" } },
    { Text = " " .. wezterm.strftime("%H:%M") .. " " },
  }))
end)

-- [+] abre seletor fuzzy de workspaces (botão direito/meio mantém nova aba)
wezterm.on("new-tab-button-click", function(window, pane, button, default_action)
  if button == "Left" then
    window:perform_action(
      wezterm.action.ShowLauncherArgs { flags = "FUZZY|WORKSPACES" },
      pane
    )
    return false
  end
end)

return config
