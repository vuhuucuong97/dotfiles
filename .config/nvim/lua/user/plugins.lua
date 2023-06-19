-- Automatically install Packer.nvim
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- automatically run :PackerCompile whenever plugins.lua is updated
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require("packer").startup({
  function(use)
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim" -- common lua functions used by other plugins
    -- List plugins here

    ---------- COLORSCHEME ----------
    use { "catppuccin/nvim", as = "catppuccin" }

    ---------- LSP ----------
    use "williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "neovim/nvim-lspconfig"
    use { "RRethy/vim-illuminate",
      config = function()
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = "#585B70", underline = true })
      end
    }
    use "b0o/schemastore.nvim"
    use "jose-elias-alvarez/null-ls.nvim"
    use { "folke/neodev.nvim", config = function()
      require("user.neodev")
    end
    }
    use {
      "nvim-treesitter/nvim-treesitter",
      run = function()
        local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
        ts_update()
      end,
    }
    use {
      "folke/trouble.nvim",
      requires = "nvim-tree/nvim-web-devicons",
      config = function()
        require("trouble").setup({})
      end
    }
    use "ray-x/lsp_signature.nvim"
    use {
      "j-hui/fidget.nvim",
      branch = 'legacy',
      config = function()
        require "fidget".setup {}
      end
    }

    ---------- COMPLETION ----------
    use "hrsh7th/cmp-nvim-lsp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-cmdline"
    use "hrsh7th/nvim-cmp"
    use({
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      tag = "v<CurrentMajor>.*",
      -- install jsregexp (optional!:).
      run = "make install_jsregexp"
    })
    use "saadparwaiz1/cmp_luasnip"
    use "rafamadriz/friendly-snippets"

    ---------- KEYMAP UI ----------
    use {
      "folke/which-key.nvim",
      config = function()
        require("user.whichkey")
      end
    }

    -- Debugger
    -- use { "mfussenegger/nvim-dap", config = function()
    --   -- require("user.dap")
    -- end
    -- }
    -- use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" }, config = function()
    --   require("dapui").setup()
    -- end
    -- }
    -- use { "mxsdev/nvim-dap-vscode-js", requires = { "mfussenegger/nvim-dap" } }
    -- -- language specific debug adapter
    -- use {
    --   "microsoft/vscode-js-debug",
    --   opt = true,
    --   run = "npm install --legacy-peer-deps && npm run compile"
    -- }

    ---------- FUZZY FINDER ----------
    use {
      "nvim-telescope/telescope.nvim", tag = "0.1.1",
      requires = {
        -- telescope plugins
        {
          "nvim-telescope/telescope-fzf-native.nvim",
          run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        }
      },
      config = function()
        require("user.telescope")
      end
    }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use { "windwp/nvim-ts-autotag", requires = { "nvim-treesitter/nvim-treesitter" }, config = function()
      require("nvim-treesitter.configs").setup {
        autotag = {
          enable = true,
        }
      }
    end }

    ---------- EXPLORER ----------
    use {
      "nvim-tree/nvim-tree.lua",
      requires = {
        "nvim-tree/nvim-web-devicons", -- optional, for file icons
      },
      config = function()
        require("user.nvim-tree")
      end

    }

    ---------- UI ----------
    use {
      "nvim-lualine/lualine.nvim",
      requires = { "kyazdani42/nvim-web-devicons", "SmiteshP/nvim-navic" },
      config = function()
        require("user.lualine")
      end
    }
    use { "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons",
      config = function()
        require("bufferline").setup {
          options = {
            diagnostics = "nvim_lsp",
            diagnostics_indicator = function(count, level, diagnostics_dict, context)
              local s = " "
              for e, n in pairs(diagnostics_dict) do
                local sym = e == "error" and " "
                    or (e == "warning" and " " or "")
                s = s .. n .. sym
              end
              return s
            end }
        }
      end
    }
    use {
      "SmiteshP/nvim-navic",
      requires = { "neovim/nvim-lspconfig" },
    }
    use({
      "utilyre/barbecue.nvim",
      tag = "*",
      requires = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      config = function()
        require("barbecue").setup()
      end,
    })
    use 'rcarriga/nvim-notify'
    use {
      "folke/noice.nvim",
      requires = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
      },
      config = function()
        require("noice").setup({
          views = {
            cmdline_popup = {
              position = {
                row = "50%",
                col = "50%",
              },
              size = {
                width = 60,
                height = "auto",
              },
            },
          },
          lsp = {
            override = {
              ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
              ["vim.lsp.util.stylize_markdown"] = true,
              ["cmp.entry.get_documentation"] = true,
            },
            signature = {
              enabled = false,
            },
          },
          presets = {
            bottom_search = false, -- use a classic bottom cmdline for search
            command_palette = true, -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false, -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false, -- add a border to hover docs and signature help
          },
        })
      end
    }
    use "norcalli/nvim-colorizer.lua"
    use { "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end
    }
    use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

    ---------- UTILS ----------
    use {
      "windwp/nvim-autopairs",
      config = function() require("nvim-autopairs").setup({}) end
    }
    use {
      "kylechui/nvim-surround",
      tag = "*",
      config = function()
        require("nvim-surround").setup({
        })
      end
    }
    use {
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("indent_blankline").setup {
          show_current_context = true,
          show_current_context_start = true,
        }
      end
    }
    use {
      "numToStr/Comment.nvim",
      requires = {
        "JoosepAlviste/nvim-ts-context-commentstring"
      },
      config = function()
        require("Comment").setup {
          pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        }
      end
    }
    use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
    })
    use { 'kevinhwang91/nvim-bqf', ft = 'qf', config = function()
      require('bqf').setup({ preview = { wrap = true } })
    end
    }

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = { snapshot_path = vim.fn.stdpath("config") .. "/packer_snapshot" }
})
