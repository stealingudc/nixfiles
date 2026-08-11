{inputs, ...}: {
  flake.nixosModules.nvim = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages = [pkgs.yazi];
    imports = [
      inputs.nvf.nixosModules.default
    ];
    programs.nvf = {
      enable = true;
      settings = {
        vim = {
          theme = {
            enable = true;
            # TODO: replace this with stylix
            name = "dracula";
          };
          # plugins
          dashboard.alpha.enable = true;
          autocomplete.nvim-cmp = {
            enable = true;
            mappings = {
              next = "<Tab>";
              previous = "<S-Tab>";
              scrollDocsDown = "<C-j>";
              scrollDocsUp = "<C-h>";
            };
            sources = {
              nvim-cmp = null;
              path = "[Path]";
              lsp = "[LSP]";
            };
            sourcePlugins = ["cmp-path" "cmp-nvim-lsp" "cmp-luasnip" "nvim-lspconfig"];
          };

          # I don't know why nvf.[...].nvim-cmp.sources
          luaConfigRC.nvim-cmp = ''
            require('cmp').setup({
                experimental = {
                    ghost_text = true
                },
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' }
                }
            })
          '';

          ui.colorizer = {
            enable = true;
            setupOpts.filetypes = {
              css = {
                RGB = true;
                RRGGBB = true;
                RRGGBBAA = true;
                names = true;
                rgb_fn = false;
                hsl_fn = false;
                css_fn = true;
                css = true;
                virtualtext = " ";
              };
            };
          };

          lazy.plugins = {
            "comment.nvim" = {
              enabled = true;
              package = pkgs.vimPlugins.comment-nvim;
              setupOpts = {
                padding = true;
                sticky = true;
                ignore = "nil";

                toggler = {
                  line = "gcc";
                  block = "<leader>/";
                };

                opleader = {
                  line = "gc";
                  block = "<leader>/";
                };
              };
            };
          };

          diagnostics = {
            enable = true;

            config = {
              virtual_text.format = lib.generators.mkLuaInline ''
                function (diagnostic)
                    return string.format("%s [%s]", diagnostic.message, diagnostic.source)
                end
              '';

              signs.text = lib.generators.mkLuaInline ''
                {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                }
              '';

              underline = true;
              update_in_insert = true;
            };
          };

          visuals = {
            indent-blankline.enable = true;
            fidget-nvim = {
              enable = true;
              setupOpts.notification.window.winblend = 0;
            };
          };

          statusline.lualine.enable = true;
          snippets.luasnip.enable = true;

          utility.snacks-nvim = {
            enable = true;
            setupOpts = {
              input.enabled = true;
              picker.enabled = true;
              notifier.enabled = true;
              terminal.enabled = true;
            };
          };

          telescope.enable = true;

          binds.whichKey = {
            enable = true;
            register = {
              "<leader>fm" = "Format Document";
            };
          };

          utility.yazi-nvim = {
            enable = true;
            mappings = {
              openYazi = "<leader>e.";
              openYaziDir = "<leader>ecw";
            };
            setupOpts.open_for_directories = true;
          };

          options = {
            tabstop = 4;
            shiftwidth = 4;
            softtabstop = 4;
            # I'm slow
            timeoutlen = 1000;
          };

          clipboard = {
            enable = true;
            registers = "unnamed,unnamedplus";
          };

          treesitter = {
            enable = true;
            highlight.enable = true;
          };
          lsp = {
            enable = true;

            lspconfig = {
              enable = true;
            };
          };

          languages = {
            enableTreesitter = true;
            enableFormat = true;
            enableExtraDiagnostics = true;

            assembly.enable = true;
            bash.enable = true;
            css.enable = true;
            go.enable = true;
            haskell.enable = true;

            kotlin.enable = true;
            lua.enable = true;
            markdown.enable = true;

            csharp = {
              enable = true;
              lsp = {
                enable = true;
              };
            };

            typescript = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["typescript-language-server"];
              };
            };

            java = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["jdt-language-server"];
              };
            };

            php = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["intelephense"];
              };
            };

            clang = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["ccls"];
              };
            };

            html = {
              enable = true;
            };

            python = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["pyright"];
              };
            };

            sql = {
              enable = true;
              format.enable = false;
              extraDiagnostics.enable = false;
            };

            vala = {
              enable = true;
              lsp.enable = true;
            };

            nix = {
              enable = true;
              lsp = {
                enable = true;
                servers = ["nil"];
              };
            };
          };

          formatter.conform-nvim = {
            enable = true;
            setupOpts.formatters_by_ft = {
              php = ["php_cs_fixer"];
              nix = ["nixfmt"];
            };
          };
          keymaps = [
            {
              mode = "n";
              key = "<Space>";
              action = "<Nop>";
            }
            {
              mode = "v";
              key = "<Space>";
              action = "<Nop>";
            }
            {
              mode = "n";
              key = ";";
              action = ":";
            }
            {
              mode = "t";
              key = "<A-h>";
              action = "<C-\><C-N><C-w>h";
            }
            {
              mode = "n";
              key = "<A-h>";
              action = "<C-w>h";
            }
            {
              mode = "t";
              key = "<A-j>";
              action = "<C-\><C-N><C-w>j";
            }
            {
              mode = "n";
              key = "<A-j>";
              action = "<C-w>j";
            }
            {
              mode = "t";
              key = "<A-k>";
              action = "<C-\><C-N><C-w>k";
            }
            {
              mode = "n";
              key = "<A-k>";
              action = "<C-w>k";
            }
            {
              mode = "t";
              key = "<A-l>";
              action = "<C-\><C-N><C-w>l";
            }
            {
              mode = "n";
              key = "<A-l>";
              action = "<C-w>l";
            }
            {
              mode = "t";
              key = "<Esc>";
              action = "<C-\><C-N><C-\><C-N>";
            }
            {
              mode = "n";
              key = "<A-=>";
              action = "<C-w>+";
            }
            {
              mode = "n";
              key = "<A-->";
              action = "<C-w>-";
            }
            {
              mode = "n";
              key = "<A-,>";
              action = "<C-w><";
            }
            {
              mode = "n";
              key = "<A-.>";
              action = "<C-w>>";
            }
            {
              desc = "Format Document";
              mode = "n";
              key = "<leader>fm";
              action = ":lua require('conform').format()<CR>";
            }
            {
              desc = "Toggle Terminal";
              mode = "n";
              key = "<leader>t";
              action = ":lua Snacks.terminal()<CR>";
            }
          ];
          globals = {
            mapleader = " ";
            maplocalleader = " ";
          };
        };
      };
    };
  };
}
