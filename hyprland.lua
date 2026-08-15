-- Omarchy Quattro loads theme-level Hyprland overrides from Lua.
-- Keep the macOS look borderless, with a visible macOS-style corner radius.
hl.config({
  general = {
    border_size = 0,
  },
  decoration = {
    rounding = 12,
    rounding_power = 4,
  },
})
