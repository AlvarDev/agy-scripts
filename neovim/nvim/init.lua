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
vim.opt.foldmethod = 'indent'     -- Fold based on code indentation levels
vim.opt.foldlevel = 99            -- Start with all folds expanded (open)
vim.opt.splitright = true         -- Vertically split to the right
vim.opt.splitbelow = true         -- Horizontally split below

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
vim.g.netrw_browse_split = 0      -- Open files in the same window (or target window if netrw_chgwin is set)
vim.g.netrw_altv = 1              -- Split vertically

-- Helper function to maintain standard window proportions
local function adjust_layout()
  local total_cols = vim.o.columns
  local tree_width = math.max(math.floor(total_cols * 0.15), 18) -- 15% of width, min 18 columns (narrower tree)
  local term_width = math.max(math.floor(total_cols * 0.30), 30) -- 30% of width, min 30 columns (stable terminal size)
  
  local netrw_win = nil
  local term_win = nil
  
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    local bt = vim.bo[buf].buftype
    if ft == 'netrw' then
      netrw_win = win
    elseif bt == 'terminal' then
      term_win = win
    end
  end
  
  if netrw_win then
    vim.api.nvim_win_set_width(netrw_win, tree_width)
  end
  if term_win then
    vim.api.nvim_win_set_width(term_win, term_width)
  end
end

-- Toggle file explorer with Space + e and enforce proper layout widths
vim.keymap.set('n', '<leader>e', function()
  vim.cmd('Lexplore')
  adjust_layout()
end, { silent = true, desc = 'Toggle File Tree' })

-- If Neovim is opened with a directory (e.g. "nvim ."), open tree on left, editor middle, terminal far-right
vim.api.nvim_create_autocmd('VimEnter', {
  callback = function()
    -- Check if the first argument passed to nvim is a directory
    if vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
      -- Close the netrw buffer that opened in the main window
      vim.cmd('bwipeout')
      -- Open Netrw on the left side
      vim.cmd('Lexplore')
      -- Move to the editor window on the right
      vim.cmd('wincmd l')
      -- Split the right window vertically and open a terminal on the far right
      vim.cmd('vsplit | terminal')
      -- Disable line numbers, relative numbers, and sign column in terminal window
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.wo.signcolumn = 'no'
      -- Force Netrw to always open selected files in Window 2 (the middle editor panel)
      vim.g.netrw_chgwin = 2
      -- Apply our layout widths
      adjust_layout()
      -- Move cursor focus back to the Netrw tree on the far left (Window 1)
      vim.cmd('1wincmd w')
    end
  end,
})

-- Automatically adjust sizes if the terminal emulator window is resized
vim.api.nvim_create_autocmd('VimResized', {
  callback = adjust_layout,
})

-- Auto-command to set up keys ONLY inside the Netrw file explorer buffer
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    -- Map 'P' to open the file and immediately jump back to the tree window
    vim.keymap.set('n', 'P', '<CR><C-w>h', { buffer = true, remap = true, silent = true, desc = 'Preview file in editor' })
    -- Override Netrw's default <C-l> mapping (refresh directory) to navigate to the right window
    vim.keymap.set('n', '<C-l>', '<C-w>l', { buffer = true, remap = true, silent = true, desc = 'Go to Right Window' })
    -- Force <CR> to open files in Window 2 (the middle editor panel)
    vim.keymap.set('n', '<CR>', ':let g:netrw_chgwin=2<CR><Plug>NetrwLocalBrowseCheck', { buffer = true, remap = true, silent = true, desc = 'Open file in editor panel' })
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

-- ==========================================================================
--  5. INTEGRATED TERMINAL HELPERS
-- ==========================================================================
-- Easy way to exit terminal insert mode with Esc
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Easy window navigation directly from terminal insert mode
vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Go to Left Window' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Go to Right Window' })

-- Automatically enter terminal insert mode when focusing a terminal buffer
vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})

-- Configure terminal appearance (disable line numbers, relative numbers, and sign column)
vim.api.nvim_create_autocmd('TermOpen', {
  pattern = '*',
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
  end,
})
