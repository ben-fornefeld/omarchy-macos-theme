-- macOS 2026 "Tahoe" — Liquid Glass, ported in full from hyprland.conf.
--
-- Border research: real macOS does NOT draw an accent-colored or gradient
-- window border. Since Big Sur it renders a fixed 1px "hairline" — a flat,
-- low-opacity neutral line (white in dark mode, black in light mode) that
-- separates a window from its surroundings; depth comes from the shadow,
-- not the border. Tahoe's Liquid Glass keeps this hairline, only letting it
-- refract nearby color at render time — it does not become a rainbow/metal
-- gradient. So the border below is a plain translucent white hairline
-- instead of the previous multi-stop chrome gradient.
local hairline_active = "rgba(FFFFFF1F)" -- ~12% white
local hairline_inactive = "rgba(FFFFFF12)" -- ~7% white
local shadow_active = "rgba(00000073)"
local shadow_inactive = "rgba(00000047)"

hl.config({
  general = {
    gaps_in = 10,
    -- Top trimmed to match gaps_in: the bar's reserved zone already pushes
    -- windows down, so the old flat 18 stacked on top of that read as a much
    -- bigger gap above windows than between them.
    gaps_out = { top = 10, right = 18, bottom = 18, left = 18 },
    border_size = 1,

    col = {
      active_border = hairline_active,
      inactive_border = hairline_inactive,
    },

    resize_on_border = true,
    extend_border_grab_area = 12,
    allow_tearing = false,
    layout = "dwindle",
  },

  group = {
    col = {
      border_active = hairline_active,
      border_inactive = hairline_inactive,
    },

    groupbar = {
      font_family = "SF Pro Display",
      font_size = 11,
      height = 24,
      gaps_in = 4,
      gaps_out = 0,
      rounding = 10,
      rounding_power = 4.0,
      text_color = "rgba(FFFFFFEE)",
      col = {
        active = { colors = { "rgba(D1D1D666)", "rgba(8E8E9366)" }, angle = 90 },
        inactive = "rgba(FFFFFF11)",
      },
      gradients = true,
    },
  },

  decoration = {
    rounding = 12,
    rounding_power = 4,

    active_opacity = 0.97,
    inactive_opacity = 0.90,
    fullscreen_opacity = 1.0,

    shadow = {
      enabled = true,
      range = 40,
      render_power = 3,
      color = shadow_active,
      color_inactive = shadow_inactive,
      offset = { 0, 12 },
    },

    blur = {
      enabled = true,
      size = 8,
      passes = 3,
      ignore_opacity = true,
      new_optimizations = true,
      xray = false,
      noise = 0.03,
      contrast = 1.1,
      brightness = 0.95,
      vibrancy = 0.28,
      vibrancy_darkness = 0.20,
    },
  },

  misc = {
    background_color = "rgb(000000)",
  },

  animations = {
    enabled = true,
  },
})

-- Bezier curves (Apple-style springs).
hl.curve("standard", { type = "bezier", points = { { 0.32, 0.72 }, { 0.00, 1.00 } } })
hl.curve("swiftOut", { type = "bezier", points = { { 0.40, 0.00 }, { 0.20, 1.00 } } })
hl.curve("swiftIn", { type = "bezier", points = { { 0.40, 0.00 }, { 1.00, 1.00 } } })
hl.curve("smooth", { type = "bezier", points = { { 0.23, 1.00 }, { 0.32, 1.00 } } })
hl.curve("snappy", { type = "bezier", points = { { 0.22, 1.00 }, { 0.35, 1.00 } } })
hl.curve("liquid", { type = "bezier", points = { { 0.20, 0.80 }, { 0.20, 1.20 } } })
hl.curve("macspring", { type = "bezier", points = { { 0.18, 1.08 }, { 0.35, 1.06 } } })
hl.curve("overshoot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.08 } } })
hl.curve("fade", { type = "bezier", points = { { 0.50, 0.50 }, { 0.75, 1.00 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.5, bezier = "macspring", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.0, bezier = "macspring", style = "popin 88%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2.2, bezier = "swiftIn", style = "popin 88%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 3.2, bezier = "snappy" })
hl.animation({ leaf = "border", enabled = true, speed = 5.0, bezier = "smooth" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 7.0, bezier = "smooth" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.0, bezier = "fade" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 2.2, bezier = "fade" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.8, bezier = "fade" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 4.0, bezier = "smooth", style = "slide" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.5, bezier = "liquid", style = "slidevert" })
hl.animation({ leaf = "layers", enabled = true, speed = 2.0, bezier = "standard" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 2.5, bezier = "overshoot", style = "popin 80%" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "swiftIn", style = "popin 90%" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.0, bezier = "fade" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.6, bezier = "fade" })

-- Blur behind translucent surfaces (bar, launcher/menu popouts, notifications, OSD).
-- This is what actually makes transparent windows/panels show blur — the
-- previous hyprland.lua only set border_size/rounding, so none of this was
-- ever applied even though hyprland.conf had it.
--
-- This system runs Omarchy's Quickshell shell, not waybar/walker/mako/swayosd,
-- so the real layer namespaces are the omarchy-* ones below (confirmed via
-- `hyprctl layers` and the shell's QML sources under /usr/share/omarchy/shell).
hl.layer_rule({ name = "macos-bar", match = { namespace = "omarchy-bar" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({
  name = "macos-menu",
  match = { namespace = "^(omarchy-menu|omarchy-image-selector|omarchy-emojis|omarchy-clipboard|omarchy-keyboard-panel)$" },
  blur = true,
  ignore_alpha = 0.2,
})
hl.layer_rule({ name = "macos-notifications", match = { namespace = "omarchy-notifications" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "macos-osd", match = { namespace = "omarchy-osd" }, blur = true, ignore_alpha = 0.2 })
hl.layer_rule({ name = "macos-hyprpicker", match = { namespace = "hyprpicker" }, blur = true })
