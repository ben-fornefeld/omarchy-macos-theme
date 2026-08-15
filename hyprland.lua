-- Omarchy Quattro loads theme-level Hyprland overrides from Lua.
-- Keep the macOS look borderless, with only a subtle corner radius.
hl.config({
  general = {
    border_size = 0,
  },
  decoration = {
    rounding = 2,
    rounding_power = 3,
  },
})
