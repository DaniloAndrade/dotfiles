local wezterm = require("wezterm")

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
  split = "#214969",
}

config.font_size = 19
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 10
config.window_padding = { left = 4, right = 4, top = 4, bottom = 4 }





-- Leader key
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 2000 }

config.keys = {
  -- Splits
  { key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "-", mods = "LEADER", action = wezterm.action.SplitVertical { domain = "CurrentPaneDomain" } },
  -- Navegação entre painéis
  { key = "h", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "j", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Down") },
  { key = "k", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "l", mods = "LEADER", action = wezterm.action.ActivatePaneDirection("Right") },
  -- Ações de painel
  { key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane { confirm = true } },
  { key = "z", mods = "LEADER", action = wezterm.action.TogglePaneZoomState },
  -- Abas
  { key = "c", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "n", mods = "LEADER", action = wezterm.action.ActivateTabRelative(1) },
  { key = "p", mods = "LEADER", action = wezterm.action.ActivateTabRelative(-1) },
  { key = ",", mods = "LEADER", action = wezterm.action.PromptInputLine {
    description = "Novo nome para a aba:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
  -- Ir para aba por número
  { key = "1", mods = "LEADER", action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "LEADER", action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "LEADER", action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "LEADER", action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "LEADER", action = wezterm.action.ActivateTab(4) },
  { key = "6", mods = "LEADER", action = wezterm.action.ActivateTab(5) },
  { key = "7", mods = "LEADER", action = wezterm.action.ActivateTab(6) },
  { key = "8", mods = "LEADER", action = wezterm.action.ActivateTab(7) },
  { key = "9", mods = "LEADER", action = wezterm.action.ActivateTab(8) },
  -- Workspaces
  { key = "S", mods = "LEADER", action = wezterm.action.PromptInputLine {
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
  { key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs { flags = "WORKSPACES" } },
  { key = "Tab", mods = "LEADER", action = wezterm.action.SwitchWorkspaceRelative(-1) },
  { key = "R", mods = "LEADER", action = wezterm.action.PromptInputLine {
    description = "Renomear workspace:",
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        wezterm.mux.rename_workspace(window:active_workspace(), line)
      end
    end),
  }},
}

-- Tab bar retro (mais compacto que o fancy)
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
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
