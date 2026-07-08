{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./keybinds-nvf.nix
    ./autocmds.nix
  ];

  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        viAlias = false;
        vimAlias = true;

        hideSearchHighlight = true;

        opts = {
          expandtab = true;
          smarttab = true;

          shiftwidth = 2;
          softtabstop = 2;
          tabstop = 2;

          breakindentopt = "shift:2,min:40,sbr";
          showbreak = "=>";
          mouse = "a";

          syntax = "enable";

          scrolloff = 5;
          splitright = true;
          switchbuf = "useopen,usetab,newtab";

          foldmethod = "manual";
        };

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers = {
            xsel.enable = true;
          };
        };

        undoFile.enable = true;

        spellcheck = {
          enable = true;
          programmingWordlist.enable = false;
          ignoredFiletypes = [
            "c"
            "cpp"
            "toggleterm"
            "python"
            "meson"
            "zig"
          ];
        };

        formatter.conform-nvim = {
          enable = true;
          setupOpts.formatters = {
            "indent".args = lib.mkForce [
              "-br"
              "-ce"
              "-cdw"
              "-ss"
              "-ncs"
              "-saf"
              "-sai"
              "-saw"
              "-di2"
              "-brf"
              "-brs"
              "-nut"
              "-i2"
              "-ci2"
              "-ip2"
              "-lp"
              "-as"
            ];
          };
        };

        lsp = {
          enable = true;

          presets.zls.enable = true;

          servers.nixd.settings.nil.nix.autoArchive = true;

          formatOnSave = true;
          lspkind.enable = true;
          trouble.enable = true;
          lightbulb.enable = false;
          lspsaga = {
            enable = true;
            setupOpts = {
              finder = {
                keys = {
                  split = "U";
                  vsplit = "u";
                };
              };
              callhierarchy = {
                keys = {
                  edit = "a";
                  split = "U";
                  vsplit = "u";
                  toggle_or_req = "k";
                };
              };
              outline = {
                close_after_jump = true;
                layout = "float";
                keys = {
                  jump = "<CR>";
                };
              };
            };
          };
          otter-nvim.enable = true;
        };

        debugger = {
          nvim-dap = {
            enable = true;
            ui.enable = false;
          };
        };

        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          enableDAP = true;

          nix = {
            enable = true;
            format.type = [ "nixfmt" ];
          };
          markdown.enable = true;

          make.enable = true;

          bash.enable = true;

          clang = {
            enable = true;
            cHeader = true;
            lsp.servers = [ "clangd" ];
            format.type = [ "indent" ];
          };
          tex.enable = true;
          python.enable = true;
          lua.enable = true;
          sql.enable = true;
          json.enable = true;
          zig.enable = true;

          typescript.enable = true;
          csharp.enable = true;
        };

        visuals = {
          nvim-scrollbar.enable = false;
          nvim-web-devicons.enable = true;
          nvim-cursorline.enable = true;
          cinnamon-nvim.enable = false;
          fidget-nvim.enable = false;
          rainbow-delimiters.enable = true;

          highlight-undo.enable = true;
          blink-indent.enable = false;
          indent-blankline.enable = false;
        };

        statusline = {
          lualine = {
            enable = true;
            activeSection = {
              a = [
                ''{ "mode", icons_enabled = true, separator = { left = '▎', right = "" }, } ''
                ''{ "", draw_empty = true, separator = { left = "", right = "" } } ''
              ];
              b = [
                ''
                  { "diff", colored = true, 
                  												diff_color = { -- Same color values as the general color option can be used here.
                  													added = 'DiffAdd', -- Changes the diff's added color 
                  													modified = 'DiffChange', -- Changes the diff's modified color
                  													removed = 'DiffDelete',}, -- Changes the diff's removed color you 
                  												symbols = {added = '+', modified = ' ~', removed = ' -'}, -- Changes the diff symbols
                  												separator = {right = ""} } ''
              ];
              c = [
                ''{ "filetype", colored = true, icon_only = true, icon = { align = 'right' } } ''
                ''{ "filename", symbols = {modified = '[+]', readonly = '[/]'}, separator = {right = ""} } ''
                ''{ "", draw_empty = true, separator = { left = "", right = "" } } ''
              ];
              x = [
                ''
                  { -- Lsp server name
                  											 function() local buf_ft = vim.bo.filetype local excluded_buf_ft = { toggleterm = true, NvimTree = true, ["neo-tree"] = true, TelescopePrompt = true } if excluded_buf_ft[buf_ft] then return "" end local bufnr = vim.api.nvim_get_current_buf() local clients = vim.lsp.get_clients({ bufnr = bufnr }) if vim.tbl_isempty(clients) then return "No Active LSP" end local active_clients = {} for _, client in ipairs(clients) do table.insert(active_clients, client.name) end return table.concat(active_clients, ", ") end, icon = '語', separator = {left = ""}, } ''
                ''
                  { "diagnostics", sources = {'nvim_lsp', 'nvim_diagnostic', 'nvim_diagnostic', 'vim_lsp', 'coc'}, symbols = {error = '󰅙 ', warn = ' ', info = ' ', hint = '󰌵 '}, colored = true, update_in_insert = false, always_visible = false, diagnostics_color = { color_error = { fg = 'red' }, color_warn = { fg = 'yellow' }, color_info = { fg = 'cyan' }, }, 
                  											} ''
              ];
              y = [
                ''{ "", draw_empty = true, separator = { left = "", right = "" } } ''
                ''{ 'searchcount', maxcount = 999, timeout = 120, separator = {left = ""} } ''
                ''{ "branch", icon = ' •', separator = {left = ""} } ''
              ];
              z = [
                ''{ "", draw_empty = true, separator = { left = "", right = "" } } ''
                ''{ "progress", separator = {left = ""} } ''
                ''{"location"} ''
                ''{ "fileformat", color = {fg='#282828'}, symbols = { unix = '' } } ''
              ];
            };
            theme = "gruvbox";
          };
        };

        highlight = {
          "DiffAdd" = {
            bg = "#504945";
            fg = "#B8BB26";
          };
          "DiffChange" = {
            bg = "#504945";
            fg = "#FABD2F";
          };
          "DiffDelete" = {
            bg = "#504945";
            fg = "#FB4934";
          };
        };

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = true;
        };

        autopairs = {
          nvim-autopairs.enable = true;
        };

        autocomplete = {
          nvim-cmp.enable = false;
          blink-cmp = {
            enable = true;
            setupOpts = {
              cmdline.enabled = false;
            };
          };
        };

        filetree = {
          neo-tree.enable = false;
        };

        lazy.plugins = with pkgs.vimPlugins; {
          "oil-git.nvim" = {
            package = oil-git-nvim;
            lazy = false;
          };
        };

        extraPlugins = with pkgs.vimPlugins; {
          nvim-lastplace = {
            package = nvim-lastplace;
            setup = "require('nvim-lastplace').setup({})";
          };
          vimtex = {
            package = vimtex;
            setup = ''
              vim.g.vimtex_view_method = "zathura"
                                    vim.g.vimtex_quickfix_mode = 0
                                    vim.g.vimtex_matchparan_enabled = 0'';
          };
          omnisharp-extended-lsp-nvim = {
            package = omnisharp-extended-lsp-nvim;
          };
          mini-cmdline = {
            package = pkgs.vimUtils.buildVimPlugin {
              name = "mini-cmdline";
              src = pkgs.fetchFromGitHub {
                owner = "nvim-mini";
                repo = "mini.nvim";
                tag = "v0.17.0";
                hash = "sha256-xmNZrQDptaNcECHSGtjownFyR1qxsP7lge8OAIFe8BU=";
              };
            };
            setup = ''
              require('mini.cmdline').setup({
              	autopeek = {
              		n_context = 3,
              	},
              })
            '';
          };
        };

        mini = {
          files = {
            enable = true;
            setupOpts = {
              mappings = {
                go_in = "o";
                go_in_plus = "O";
                go_out = "n";
                go_out_plus = "N";
                synchronize = "W";
                close = "<Esc>";
              };
              windows = {
                preview = true;
              };
            };
          };

          indentscope = {
            enable = true;
            setupOpts = {
              draw.delay = 10;
              mappings.object_scope = "ui";
            };
          };

          cursorword.enable = true;
          hipatterns.enable = true;
          notify.enable = true;
          tabline.enable = true;
        };

        tabline = {
          nvimBufferline = {
            enable = false;
            setupOpts = {
              options = {
                show_close_icon = false;
                show_buffer_close_icons = false;
                enforce_regular_tabs = false;
                separator_style = "thin";
                indicator.style = "none";
                modified_icon = "";
                numbers = "none";
                sort_by = "insert_at_end";
                diagnostics = false;
                style_preset = "no_italic";
                offsets = [ ];
              };
            };
          };
        };

        treesitter = {
          context.enable = false;
        };

        binds = {
          whichKey.enable = false;
          cheatsheet.enable = false;
        };

        telescope = {
          enable = true;
          extensions = [
            {
              name = "fzf";
              packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
              setup = {
                fzf = {
                  fuzzy = true;
                };
              };
            }
          ];
        };

        git = {
          enable = true;
          gitsigns.enable = true;
          gitsigns.codeActions.enable = false;
          neogit.enable = true;
        };

        minimap = {
          minimap-vim.enable = false;
          codewindow.enable = false; # TODO want but broken
        };

        dashboard = {
          dashboard-nvim.enable = false;
          alpha.enable = false;
        };

        notify = {
          nvim-notify = {
            enable = false;
            setupOpts = {
              background_colour = "#000000";
            };
          };
        };

        projects = {
          project-nvim.enable = false;
        };

        utility = {
          ccc.enable = false;
          vim-wakatime.enable = false;
          diffview-nvim.enable = false;

          yanky-nvim = {
            enable = true;
            setupOpts.ring.storage = "memory";
          };
          oil-nvim = {
            enable = true;
            gitStatus.enable = false;
            setupOpts = {
              use_default_keymaps = false;
              keymaps = {
                "<Space>tt" = "actions.close";
                "<CR>" = "actions.select";
              };
              view_options = {
                show_hidden = true;
              };
              float = {
                padding = 10;
                border = "rounded";
                max_width = 0.6;
                max_height = 0.8;
                win_options = {
                  winblend = 15;
                  winhl = "NormalFloat:OilFloat";
                };
              };
              confirmation.border = config.programs.nvf.settings.vim.utility.oil-nvim.setupOpts.float.border;
              progress.border = config.programs.nvf.settings.vim.utility.oil-nvim.setupOpts.float.border;
            };
          };

          qmk-nvim.enable = false; # requires hardware specific options
          icon-picker.enable = false;
          surround.enable = true;
          leetcode-nvim.enable = false;
          multicursors.enable = true;
          smart-splits.enable = false;
          undotree.enable = false;
          nvim-biscuits.enable = true; # TODO want but broken
          grug-far-nvim.enable = false;

          motion = {
            hop.enable = false;
            leap.enable = false;
            # precognition.enable = true;
          };

          images = {
            image-nvim.enable = false;
            img-clip.enable = false;
          };
        };

        notes = {
          neorg.enable = true;
          orgmode.enable = false;
          todo-comments.enable = false;
          obsidian = {
            enable = true;
            setupOpts = {
              workspaces = [
                {
                  name = "Knowledge";
                  path = "~/Documents/obsidian/Knowledge";
                }
              ];
              legacy_commands = false;
              ui = {
                enable = false;
              };
            };
          };
        };

        ui = {
          borders = {
            enable = false;
            globalStyle = "double";
          };
          noice.enable = false;
          colorizer.enable = false;
          modes-nvim.enable = true;
          illuminate.enable = false;
          breadcrumbs = {
            enable = false;
            navbuddy.enable = true;
          };
          smartcolumn.enable = false;
          fastaction.enable = true;
        };

        assistant = {
          chatgpt.enable = false;
          copilot.enable = false;
          codecompanion-nvim.enable = false;
          avante-nvim.enable = false;
        };

        session = {
          nvim-session-manager.enable = false;
        };

        gestures = {
          gesture-nvim.enable = false;
        };

        presence = {
          neocord.enable = false;
        };
      };
    };
  };
}
