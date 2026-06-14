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

-- Leader key
config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- Splits
  { key = "|", mods = "LEADER", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
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
}

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

-- Status: workspace à esquerda, hora à direita
wezterm.on("update-right-status", function(window, pane)
  local workspace = window:active_workspace()
  local time = wezterm.strftime("%H:%M")

  window:set_left_status(wezterm.format({
    { Foreground = { Color = "#47FF9C" } },
    { Text = " [" .. workspace .. "] " },
  }))

  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#CBE0F0" } },
    { Text = " " .. time .. " " },
  }))
end)

return config
