
-- Aliases
local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local o = vim.o
local bo = vim.bo
local wo = vim.wo

-- Functions
local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
