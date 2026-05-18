-- macOS 2026 "Tahoe" — Neovim
-- Derived from style-plan.json apps.neovim
-- Uses tokyonight-moon as the closest-in-hue scheme to Tahoe dark grays.

return {
	{
		"folke/tokyonight.nvim",
		priority = 1000,
	},
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight-moon",
		},
	},
}
