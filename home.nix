{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles;

  mkLanguageOption = language: {
    ${language} = mkOption {
      default = false;
      description = "Include ${language} tools";
      type = types.bool;
    };
  };

  neovimModule = types.submodule
    ({ config, ... }: {
      options =
        {
          enable = mkEnableOption "Add neovim and its chosen dependencies";
        }
        // mkLanguageOption "bash"
        // mkLanguageOption "cmake"
        // mkLanguageOption "c_cpp"
        // mkLanguageOption "rust"
        // mkLanguageOption "zig"
        // mkLanguageOption "gdscript"
        // mkLanguageOption "json"
        // mkLanguageOption "yaml"
        // mkLanguageOption "lua"
        // mkLanguageOption "python"
        // mkLanguageOption "nix"
        // mkLanguageOption "javascript_typescript";
    });
in
{
  options = {
    dotfiles = {
      enable = mkEnableOption "Jonathan's dotfiles";

      terminal-tools = mkOption {
        default = false;
        description = "Include tools mostly used from the terminal";
        type = types.bool;
      };

      neovim = mkOption {
        default = { };
        description = "Options related to neovim language dependencies";
        type = neovimModule;
      };

      gui = mkOption {
        default = false;
        description = "Include tools used from graphical contexts";
        type = types.bool;
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        optionals cfg.terminal-tools [ ripgrep fd unzip ]
        ++ optionals cfg.neovim.enable (
          [ tree-sitter ]
          ++ optionals cfg.neovim.bash [
            bash-language-server
            shfmt
          ]
          ++ optionals cfg.neovim.cmake [
            cmake-lint
            neocmakelsp
          ]
          ++ optionals cfg.neovim.c_cpp [ clang-tools ]
          ++ optionals (cfg.neovim.c_cpp || cfg.neovim.rust || cfg.neovim.zig)
            [ vscode-extensions.vadimcn.vscode-lldb ]
          ++ optionals cfg.neovim.rust [
            rust-analyzer
          ]
          ++ optionals cfg.neovim.zig [
            zls
          ]
          ++ optionals cfg.neovim.gdscript [
            gdtoolkit_4
          ]
          ++ optionals cfg.neovim.json [
            nodePackages.vscode-json-languageserver
          ]
          ++ optionals cfg.neovim.yaml [
            yaml-language-server
          ]
          ++ optionals cfg.neovim.lua [
            lua-language-server
            selene
            stylua
          ]
          ++ optionals cfg.neovim.python [
            mypy
            pyright
            ruff
            python313Packages.debugpy
          ]
          ++ optionals cfg.neovim.nix [
            nil
            nixpkgs-fmt
          ]
          ++ optionals cfg.neovim.javascript_typescript [
            typescript-language-server
            prettierd
          ]
        )
        ++ [
          # other tools
          inotify-tools
          vim # for rvim
        ]
        ++ optionals cfg.gui [
          (config.lib.nixGL.wrap ghostty)
          (config.lib.nixGL.wrap waybar)
          (config.lib.nixGL.wrap qutebrowser)
          dunst
          wl-clipboard
        ];
    };

    xdg.configFile.nvim = {
      enable = cfg.neovim.enable;
      recursive = true;
      source = ./config/nvim;
    };

    xdg.configFile.ghostty = {
      enable = cfg.gui;
      recursive = true;
      source = ./config/ghostty;
    };

    xdg.configFile.sway = {
      enable = cfg.gui;
      recursive = true;
      source = ./config/sway;
    };

    xdg.configFile.waybar = {
      enable = cfg.gui;
      recursive = true;
      source = ./config/waybar;
    };

    xdg.configFile.dunst = {
      enable = cfg.gui;
      recursive = true;
      source = ./config/dunst;
    };

    programs = {
      # shell
      zsh = {
        enable = cfg.terminal-tools;
        dotDir = ".config/zsh";
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        autocd = true;
        enableCompletion = true;
        initExtraBeforeCompInit = ''
          HYPHEN_INSENSITIVE="true"
          COMPLETION_WAITING_DOTS="true"
        '';
        initExtra = ''
          bindkey '^ ' autosuggest-accept

          # Allows fuzzy matching of completions in the presence of typos
          zstyle ':completion:*' completer _complete _match _approximate
          zstyle ':completion:*:match:*' original only
          zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

          # Do not suggest the ./ and ../$(current-directory)
          zstyle ':completion:*:cd:*' ignore-parents parent pwd
        '';
        shellAliases = {
          g = "git";
          dg = "git --git-dir=$HOME/dotfiles/";
          updatedb = "updatedb --require-visibility 0 -o $HOME/.cache/locate.db";
          locate = "locate --database=$HOME/.cache/locate.db";
        };
        oh-my-zsh = {
          enable = true;
          theme = "af-magic";
          plugins = [ "vi-mode" "fzf" "zoxide" "command-not-found" ];
          extraConfig = ''
            DISABLE_UNTRACKED_FILES_DIRTY="true"
          '';
        };
      };

      fzf = {
        enable = cfg.terminal-tools;
        enableZshIntegration = true;
      };

      zoxide = {
        enable = cfg.terminal-tools;
        enableZshIntegration = true;
      };

      # IDE
      neovim = mkIf cfg.neovim.enable {
        enable = cfg.neovim.enable;
        defaultEditor = true;
      };

      # PDF viewer
      zathura = {
        enable = cfg.gui;
        options = {
          recolor = true;
          recolor-keephue = true;
        };
      };

      wofi = {
        enable = cfg.gui;
        package = (config.lib.nixGL.wrap pkgs.wofi);
      };
    };

    xdg.portal = {
      enable = cfg.gui;
      config = {
        common = {
          default = [
            "wlr"
            "gtk"
          ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };

    # window manager
    wayland.windowManager.sway = {
      package = (config.lib.nixGL.wrap pkgs.sway);
      enable = cfg.gui;
      systemd.enable = true;
      systemd.xdgAutostart = true;
    };
  };
}
