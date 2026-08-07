-- ==========================================================================
--  1. CORE SETTINGS (VIM OPTIONS)
-- ==========================================================================
vim.opt.number = true             -- Show line numbers
vim.opt.relativenumber = true     -- Show relative line numbers (helpful for jumps)
vim.opt.mouse = 'a'               -- Enable mouse support in all modes
vim.opt.clipboard = 'unnamedplus'    -- Sync clipboard with system clipboard (copy/paste from Mac)
vim.opt.tabstop = 4               -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4            -- Number of spaces for autoindent
vim.opt.expandtab = true          -- Convert tabs to spaces
vim.opt.smartindent = true        -- Insert indents automatically
vim.opt.ignorecase = true         -- Case-insensitive search
vim.opt.smartcase = true          -- Case-sensitive search if capital letter used
vim.opt.hlsearch = true           -- Highlight search results
vim.opt.termguicolors = true      -- Enable 24-bit RGB colors
vim.opt.path:append('**')         -- Search all subdirectories recursively when using :find

-- Map leader key to Space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear search highlights with Esc in normal mode
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>', { silent = true })

-- Set color scheme (Catppuccin Mocha - a high-quality dark mode)
vim.cmd('colorscheme catppuccin-mocha')

-- Override Identifier (keys in YAML/Terraform) to Catppuccin's soft red
vim.api.nvim_set_hl(0, 'Identifier', { fg = '#f38ba8' })

-- Easy window navigation (jump between tree and code easily)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window' })

-- ==========================================================================
--  2. NATIVE FILE EXPLORER (NETRW)
-- ==========================================================================
vim.g.netrw_banner = 0            -- Hide the help banner at the top
vim.g.netrw_liststyle = 3         -- Use tree-style view
vim.g.netrw_winsize = 25          -- Width is 25% of the window
vim.g.netrw_browse_split = 4      -- Open files in the previous window (keep tree open)
vim.g.netrw_altv = 1              -- Split vertically

-- Toggle file explorer with Space + e
vim.keymap.set('n', '<leader>e', ':Lexplore<CR>', { silent = true, desc = 'Toggle File Tree' })

-- If Neovim is opened with a directory (e.g. "nvim ."), open the tree on the left and a blank file on the right
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Check if the first argument passed to nvim is a directory
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      -- Close the netrw buffer that opened in the main window
      vim.cmd('bwipeout')
      -- Open Netrw on the left side
      vim.cmd('Lexplore')
    end
  end,
})

-- Auto-command to set up keys ONLY inside the Netrw file explorer buffer
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    -- Map 'P' to open the file and immediately jump back to the tree window
    vim.keymap.set('n', 'P', '<CR><C-w>h', { buffer = true, remap = true, silent = true, desc = 'Preview file in editor' })
  end,
})

-- ==========================================================================
--  3. NATIVE AUTO-COMPLETION (Buffer-only)
-- ==========================================================================
-- Configure completion popup behavior
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

-- Auto-trigger autocomplete as you type using words in active files
vim.api.nvim_create_autocmd('InsertCharPre', {
  pattern = '*',
  callback = function()
    -- Only trigger completion if typing a letter
    if vim.fn.pumvisible() == 0 and vim.v.char:match('%a') then
      vim.schedule(function()
        -- Trigger native buffer-word completion
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, false, true), 'n')
      end)
    end
  end,
})

-- Map Tab to navigate completion popup if visible
vim.keymap.set('i', '<Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })
vim.keymap.set('i', '<S-Tab>', function()
  return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

-- ==========================================================================
--  4. NATIVE GIT DIFF VISUALIZER
-- ==========================================================================
-- Open git diff in a terminal within a new tab (press Space + g + d)
vim.keymap.set('n', '<leader>gd', ':tabedit | term git diff<CR>', { silent = true, desc = 'Git Diff in Terminal Tab' })
