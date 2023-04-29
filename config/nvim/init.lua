--[[ init.lua ]]

vim.g.load_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Impatient for faster loading
require('impatient')

-- LEADER
vim.g.mapleader = " " -- works across all nvim files

-- Color theme
vim.cmd([[colorscheme gruvbox-material]])
vim.cmd([[highlight Cursor guifg=gray guibg=gray]])
vim.cmd([[highlight iCursor guifg=gray guibg=gray]])

-- IMPORTS
require('vars') -- Variables
require('opts') -- Options
require('keys') -- Keymaps
require('plug') -- Plugins

-- Lua line
require('lualine').setup {
    options = {
        theme = 'gruvbox-material',
        fmt = string.lower,
        -- component_separators = { left = '', right = '' },
        -- section_separators = { left = '', right = '' },
    }
}

----------------------------------------
-- PLUGINS initialization           ----
----------------------------------------

-- Fidget - show status of LSP progress
require "fidget".setup {
    window = {
        relative = "editor",
        blend = 10,
    },
}


-- Hop
require 'hop'.setup {
    keys = 'etovxqpdygfblzhckisuran',
    jump_on_sole_occurrence = false,
}

require("indent_blankline").setup {
    -- char = '┊',
    char = ' ',
    use_treesitter = true,
    use_treesitter_scope = true,
    show_first_indent_level = true,
    space_char_blankline = " ",
}

-- Trouble Setup
require('trouble').setup {
    position = "right",
    width = 70,
    padding = true,
    auto_preview = false,
}


-- Nvim Tree Setup
require('nvim-tree').setup {
    sort_by = "case_sensitive",
    open_on_setup = true,
    update_focused_file = {
        enable = true,
    },
    view = {
        adaptive_size = false,
        mappings = {
            list = {
                { key = "u", action = "dir_up" },
            },
        },
    },
    renderer = {
        group_empty = true,
        icons = {
            git_placement = "after",
            glyphs = {
                git = {
                    unstaged = "~",
                    staged = "s",
                    untracked = "u",
                    ignored = "i",
                },
            },
        },
    },
    filters = {
        dotfiles = false,
    },
    git = {
        ignore = true,
    },
}
local function open_nvim_tree(data)
    local real_file = vim.fn.filereadable(data.file) == 1
    local no_name = data.file == "" and vim.bo[databuf].buftype == ""
    if not real_file and not no_name then
        return
    end

    require("nvim-tree.api").tree.toggle({ focus = false, find_file = true, })
end
vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })



-- Telescope Setup
require('telescope').setup {
    defaults = {
        file_ignore_patterns = {
            "^./.git/",
            "^./target/",
            "LICENSE*"
        },
        layout_strategy = 'horizontal',
        layout_config = { height = 0.90, width = 0.90 },
    },
    pickers = {
        find_files = {
            theme = "dropdown",
        }
    }
}

-- Get fzf loaded and working with extension
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('live_grep_args')


-- Autopairs Setup
require 'nvim-autopairs'.setup {}



-- Mason Setup
require("mason").setup({
    ui = {
        icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
        },
    }
})
require("mason-lspconfig").setup()


----------------------------------------
-- LSP Server Configurations        ----
----------------------------------------

-- LSP Config
local nvim_lsp = require 'lspconfig'

----------------------------------------
-- COMPLETION Setup                 ----
----------------------------------------

require('lspkind').init({
    -- mode = 'symbol_text'
})


vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 100)

local lspkind = require('lspkind')
local cmp = require 'cmp'

cmp.setup({
    -- Enable LSP snippets
    snippet = {
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For 'vsnip' users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
    },
    mapping = {
        -- Add tab support
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm { select = false }
    },
    -- Installed sources:
    sources = {
        { name = 'path' }, -- file paths
        { name = 'nvim_lsp', keyword_length = 1, priority = 10 }, -- from language server
        { name = 'nvim_lsp_signature_help', priority = 8 }, -- display function signatures with current parameter emphasized
        { name = 'nvim_lua', keyword_length = 1, priority = 8 }, -- complete neovim's Lua runtime API such vim.lsp.*
        { name = 'buffer', keyword_length = 1, priority = 5 }, -- source current buffer
        -- { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
        { name = 'calc' }, -- source for math calculation
    },
    window = {
        completion = {
            cmp.config.window.bordered(),
            col_offset = 3,
            side_padding = 1,
        },
        documentation = cmp.config.window.bordered(),

    },
    formatting = {
        fields = { 'menu', 'abbr', 'kind' },
        format = lspkind.cmp_format({
            mode = 'symbol_text', -- show only symbol annotations
            maxwidth = 60, -- prevent the popup from showing more than provided characters
            -- The function below will be called before any actual modifications from lspkind:
            before = function(entry, vim_item)
                local menu_icon = {
                    nvim_lsp = 'λ ',
                    luasnip = '⋗ ',
                    buffer = 'Ω ',
                    path = '📁 ',
                }
                vim_item.menu = menu_icon[entry.source.name]
                return vim_item
            end,
        })

    },
    preselect = cmp.PreselectMode.None,
    confirmation = {
        get_commit_characters = function(commit_characters)
            return {}
        end
    },
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})



----------------------------------------
-- TREE-SITTER Setup                ----
----------------------------------------

require('nvim-treesitter.configs').setup {
    ensure_installed = {"dockerfile", "hcl", "vimdoc", "html", "javascript", "json", "lua", "make", "markdown", "python", "regex", "rust", "toml", "yaml" },
    auto_install = true,
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<S-Tab>", -- normal mode
            node_incremental = "<Tab>", -- visual mode
            node_decremental = "<S-Tab", -- visual mode
        },
    },
    ident = { enable = true },
    rainbow = {
        enable = true,
    }
}

------------------------------------
-- DIFFVIEW                     ----
-- -https://github.com/sindrets/diffview.nvim
-- --------------------------------
-- Lua
local actions = require("diffview.actions")

require("diffview").setup({
})



