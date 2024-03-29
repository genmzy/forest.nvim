local util = require("forest.util")

local M = {}

---@class Palette
M.default = {
  none = "NONE",
  bg_dark = "#f7f2e0", --
  bg = "#fff9e8", --
  bg_highlight = "#f0eed9", --
  terminal_black = "#dcd8c4", --
  fg = "#5c6a72", --
  fg_dark = "#92978c", --
  fg_gutter = "#e9e8d2",
  dark3 = "#a0a79a",
  comment = "#999f93", --
  dark5 = "#576268",
  blue0 = "#C1D1C8", --
  blue = "#41A8B0", --
  cyan = "#35a77c", --
  blue1 = "#FF8E5E", --
  blue2 = "#41BDB0",
  blue5 = "#749A9F",
  blue6 = "#b4f9f8", --
  blue7 = "#394b70",
  purple = "#f85552", --
  magenta2 = "#d699b6",
  magenta = "#d67ba7", --
  orange = "#f57d26", --
  yellow = "#dfa000", --
  green = "#8da101", --
  green1 = "#35a77c", --
  green2 = "#636835",
  teal = "#4fd6be", --
  red = "#f85552", --
  red1 = "#e67e80", --
}

M.default.comment = util.blend(M.default.comment, M.default.bg, "bb")
M.default.git = {
  change = util.blend(M.default.blue, M.default.bg, "ee"),
  add = util.blend(M.default.green, M.default.bg, "ee"),
  delete = util.blend(M.default.red, M.default.bg, "dd"),
}
M.default.gitSigns = {
  change = util.blend(M.default.blue, M.default.bg, "66"),
  add = util.blend(M.default.green, M.default.bg, "66"),
  delete = util.blend(M.default.red, M.default.bg, "aa"),
}

---@return ColorScheme
function M.setup(opts)
  opts = opts or {}
  local config = require("forest.config")

  local style = config.is_day() and config.options.light_style or config.options.style
  local palette = M[style] or {}
  if type(palette) == "function" then
    palette = palette()
  end

  -- Color Palette
  ---@class ColorScheme: Palette
  local colors = vim.tbl_deep_extend("force", vim.deepcopy(M.default), palette)

  util.bg = colors.bg
  util.day_brightness = config.options.day_brightness

  colors.diff = {
    add = util.darken(colors.green2, 0.15),
    delete = util.darken(colors.red1, 0.15),
    change = util.darken(colors.blue7, 0.15),
    text = colors.blue7,
  }

  colors.git.ignore = colors.dark3
  colors.black = util.lighten(colors.bg, 0.8, "#ffffff")
  colors.border_highlight = util.darken(colors.blue1, 0.8)
  colors.border = colors.black

  -- Popups and statusline always get a dark background
  colors.bg_popup = colors.bg_dark
  colors.bg_statusline = colors.bg_dark

  -- Sidebar and Floats are configurable
  colors.bg_sidebar = config.options.styles.sidebars == "transparent" and colors.none
    or config.options.styles.sidebars == "dark" and colors.bg_dark
    or colors.bg

  colors.bg_float = config.options.styles.floats == "transparent" and colors.none
    or config.options.styles.floats == "dark" and colors.bg_dark
    or colors.bg

  colors.bg_visual = util.darken(colors.blue0, 0.4)
  colors.bg_search = colors.blue0
  colors.fg_sidebar = colors.fg_dark
  -- colors.fg_float = config.options.styles.floats == "dark" and colors.fg_dark or colors.fg
  colors.fg_float = colors.fg

  colors.error = colors.red1
  colors.todo = colors.blue
  colors.warning = colors.yellow
  colors.info = colors.blue2
  colors.hint = colors.teal

  colors.delta = {
    add = util.darken(colors.green2, 0.45),
    delete = util.darken(colors.red1, 0.45),
  }

  config.options.on_colors(colors)
  if opts.transform and config.is_day() then
    util.invert_colors(colors)
  end

  return colors
end

return M
