-- since this is just an example spec, don't actually load anything here and return an empty spec

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
    -- add gruvbox
    { "sainnhe/gruvbox-material" },

    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "gruvbox-material",
        },
    },

    -- change trouble config
    {
        "folke/trouble.nvim",
        -- opts will be merged with the parent spec
        opts = { use_diagnostic_signs = true },
    },

    -- change some telescope options and a keymap to browse plugin files
    {
        "nvim-telescope/telescope.nvim",
        -- change some options
        opts = {
            defaults = {
                prompt_prefix = "🔍",
                vimgrep_arguments = {
                    "rg",
                    "--color=never",
                    "--no-heading",
                    "--with-filename",
                    "--line-number",
                    "--column",
                    "--smart-case",
                    "--hidden",
                    "--glob!=.git/",
                },
            },
        },
    },

    -- add telescope-fzf-native
    {
        "telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
            },
            {
                "nvim-telescope/telescope-live-grep-args.nvim",
                version = "^1",
            },
        },
        config = function()
            require("telescope").load_extension("fzf")
            require("telescope").load_extension("live_grep_args")
        end,
    },

    {
        "ruanyl/vim-gh-line",
        lazy = false,
        config = function()
            vim.g.gh_open_command = 'fn() { echo "$@" | pbcopy; }; fn '
            -- vim.g.gh_gitlab_domain
            vim.g.gh_always_interactive = 0
        end,
    },
    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        lazy = false,
        opts = {
            attach_navic = false,
        },
    },

    -- could add:
    -- j-hui/fidget
    -- smoka7/hop

    -- Use <tab> for completion and snippets (supertab)
    -- first: disable default <tab> and <s-tab> behavior in LuaSnip
    {
        "L3MON4D3/LuaSnip",
        keys = function()
            return {}
        end,
    },
    -- then: setup supertab in cmp
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api
                            .nvim_buf_get_lines(0, line - 1, line, true)[1]
                            :sub(col, col)
                            :match("%s")
                        == nil
            end

            local luasnip = require("luasnip")
            local cmp = require("cmp")

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                    -- this way you will only jump inside the snippet region
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })
        end,
    },


    -- bug fix for rust-tools
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
          {
            "Saecki/crates.nvim",
            event = "BufRead Cargo.toml",
            config = function(_, opts)
              require("crates").setup(opts)
    
              local register_keys = function()
                local wk = require("which-key")
    
                wk.register({
                  ["<cr>"] = { require("crates").show_popup, "Crates Popup" },
                }, {
                  buffer = vim.api.nvim_get_current_buf(),
                })
              end
    
              register_keys()
              vim.api.nvim_create_autocmd("BufReadPost", { pattern = "Cargo.toml", callback = register_keys })
            end,
            opts = {
              src = {
                cmp = {
                  enabled = true,
                },
              },
              popup = {
                autofocus = true,
                hide_on_select = true,
                border = "rounded",
              },
            },
          },
        },
        opts = function(_, opts)
          local cmp = require("cmp")
          opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
            { name = "crates" },
          }))
        end,
      },
    
      -- Add Rust & related to treesitter
      {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, { "ron", "rust", "toml" })
          end
        end,
      },
    
      -- Ensure Rust debugger is installed
      {
        "williamboman/mason.nvim",
        optional = true,
        opts = function(_, opts)
          if type(opts.ensure_installed) == "table" then
            vim.list_extend(opts.ensure_installed, { "codelldb" })
          end
        end,
      },
    
      {
        "mrcjkb/rustaceanvim",
        ft = { "rust" },
        opts = {
          server = {
            on_attach = function(_, bufnr)
              -- register which-key mappings
              local wk = require("which-key")
              wk.register({
                ["<leader>cR"] = {
                  function()
                    vim.cmd.RustLsp("codeAction")
                  end,
                  "Code Action",
                },
                ["<leader>dr"] = {
                  function()
                    vim.cmd.RustLsp("debuggables")
                  end,
                  "Rust debuggables",
                },
              }, { mode = "n", buffer = bufnr })
            end,
            settings = {
              -- rust-analyzer language server configuration
              ["rust-analyzer"] = {
                assist = {
                  emitMustUse = true,
                },
                completion = {
                  privateEditable = {
                    enable = true,
                  },
                },
                diagnostics = {
                  enable = false,
                  experimental = {
                    enable = true,
                  },
                  previewRustcOutput = true,
                  useRustcErrorCode = true,
                },
                hover = {
                  actions = {
                    references = {
                      enable = true,
                    },
                  },
                },
                imports = {
                  granularity = {
                    enforce = true,
                  },
                  prefer = {
                    no = {
                      std = true,
                    },
                  },
                },
                inlayHint = {
                  dynamicRegistration = true,
                  resolveSupport = {
                    properties = {},
                  },
                },
                interpret = {
                  tests = true,
                },
                lens = {
                  references = {
                    enumVariant = {
                      enable = true,
                    },
                    method = {
                      enable = true,
                    },
                    trait = {
                      enable = true,
                    },
                    adt = {
                      enable = true,
                    },
                  },
                },
                debug = {
                  openDebugPane = true,
                },
                restartServerOnConfigChange = true,
                rustfmt = {
                  overrideCommand = { "rustup", "run", "stable", "rustfmt" },
                  rangeFormatting = {
                    enable = true,
                  },
                },
                semanticHighlighting = {
                  operator = {
                    enable = true,
                    specialization = {
                      enable = true,
                    },
                  },
                  strings = {
                    enable = true,
                  },
                  doc = {
                    comment = {
                      inject = {
                        enable = true,
                      },
                    },
                  },
                  punctuation = {
                    enable = true,
                    separate = {
                      macro = {
                        bang = true,
                      },
                    },
                    specialization = {
                      enable = true,
                    },
                  },
                },
                typing = {
                  autoClosingAngleBrackets = {
                    enable = true,
                  },
                },
                cargo = {
                  allFeatures = true,
                  loadOutDirsFromCheck = true,
                  runBuildScripts = true,
                },
                procMacro = {
                  enable = true,
                  attributes = { enable = true },
                },
                lru = {
                    capacity = 8192
                },
                files = {
                    excludeDirs = {
                        ".git",
                        ".venv",
                        "bin",
                        "target",
                        ".vscode",
                        "data",
                        ".idea",
                        ".direnv",
                        ".terraform",
                    }
                }
              },
            },
          },
        },
        config = function(_, opts)
          vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
        end,
      },
    
      -- Correctly setup lspconfig for Rust 🚀
      {
        "neovim/nvim-lspconfig",
        opts = {
          servers = {
            rust_analyzer = {},
            taplo = {
              keys = {
                {
                  "K",
                  function()
                    if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                      require("crates").show_popup()
                    else
                      vim.lsp.buf.hover()
                    end
                  end,
                  desc = "Show Crate Documentation",
                },
              },
            },
          },
          setup = {
            rust_analyzer = function()
              return true
            end,
          },
        },
      },
    
      {
        "nvim-neotest/neotest",
        optional = true,
        dependencies = {
          "rouge8/neotest-rust",
        },
        opts = {
          adapters = {
            ["neotest-rust"] = {},
          },
        },
      },
}
