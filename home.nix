{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.dotfiles;

  mkToolsOption = language: {
    ${language} = mkOption {
      default = false;
      description = "Include ${language} tools";
      type = types.bool;
    };
  };

  neovimModule = types.submodule ({ config, ... }: {
    options =
      { enable = mkEnableOption "Add neovim and its chosen dependencies"; }
      // mkToolsOption "bash"
      // mkToolsOption "cmake"
      // mkToolsOption "c_cpp"
      // mkToolsOption "rust"
      // mkToolsOption "zig"
      // mkToolsOption "gdscript"
      // mkToolsOption "json"
      // mkToolsOption "yaml"
      // mkToolsOption "lua"
      // mkToolsOption "python"
      // mkToolsOption "nix"
      // mkToolsOption "javascript_typescript";
  });

  guiModule = types.submodule ({ config, ... }: {
    options = {
      enable = mkEnableOption "Add tools which require graphics backend";
    }
    // mkToolsOption "3d"
    // mkToolsOption "2d";
  });

in
{
  options = {
    dotfiles = {
      enable = mkEnableOption "Jonathan's dotfiles";

      shell-tools = mkOption {
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
        default = { };
        description = "Options related to applications requiring graphics backend";
        type = guiModule;
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        optionals cfg.shell-tools [
          # modern grep
          ripgrep
          # modern find
          fd
          unzip
          # help about various commands and linux concepts
          man
          man-pages
          # locate directories and files around the file system
          plocate
          # view images in terminal, good quality if kitty graphics protocol
          # is supported by the terminal
          viu
        ]
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
        ++ optionals cfg.gui.enable (
          [
            # taskbar
            (config.lib.nixGL.wrap waybar)
            # screenshot
            (config.lib.nixGL.wrap grim)
            (config.lib.nixGL.wrap slurp)
            (config.lib.nixGL.wrap swappy)
            # notification
            dunst
            # clipboard
            wl-clipboard
            # browser
            (config.lib.nixGL.wrap pkgs.qutebrowser)
            # fonts
            noto-fonts
            noto-fonts-color-emoji
          ]
          ++ optionals cfg.gui."3d" [
            (config.lib.nixGL.wrap blender-hip)
          ]
          ++ optionals cfg.gui."2d" [
            (config.lib.nixGL.wrap krita)
          ]
        );

      sessionVariables = {
        VISUAL = mkIf cfg.neovim.enable "nvim";
        PAGER = mkIf cfg.neovim.enable "nvim -R";
        MANPAGER = mkIf cfg.neovim.enable "nvim -R +Man!";
        SUDO_EDITOR = "rvim";
        BROWSER = mkIf cfg.gui.enable "qutebrowser";
      };
    };

    xdg.configFile.nvim = {
      enable = cfg.neovim.enable;
      recursive = true;
      source = ./config/nvim;
    };

    xdg.configFile.sway = {
      enable = cfg.gui.enable;
      recursive = true;
      source = ./config/sway;
    };

    xdg.configFile.swappy = {
      enable = cfg.gui.enable;
      recursive = true;
      source = ./config/swappy;
    };

    xdg.configFile.waybar = {
      enable = cfg.gui.enable;
      recursive = true;
      source = ./config/waybar;
    };

    xdg.configFile.dunst = {
      enable = cfg.gui.enable;
      recursive = true;
      source = ./config/dunst;
    };

    xdg.configFile.qutebrowser = {
      enable = cfg.gui.enable;
      recursive = true;
      source = ./config/qutebrowser;
    };

    programs = {
      # shell
      zsh = {
        enable = cfg.shell-tools;
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
        enable = cfg.shell-tools;
        enableZshIntegration = true;
      };

      zoxide = {
        enable = cfg.shell-tools;
        enableZshIntegration = true;
      };

      # IDE
      neovim = mkIf cfg.neovim.enable {
        enable = cfg.neovim.enable;
        defaultEditor = true;
      };

      # PDF viewer
      zathura = {
        enable = cfg.gui.enable;
        options = {
          recolor = true;
          recolor-keephue = true;
        };
      };

      wofi = {
        enable = cfg.gui.enable;
        package = (config.lib.nixGL.wrap pkgs.wofi);
      };

      ghostty = {
        package = (config.lib.nixGL.wrap pkgs.ghostty);
        enable = cfg.gui.enable;
        settings = { window-decoration = false; };
      };

      mpv = {
        package = (config.lib.nixGL.wrap pkgs.mpv);
        enable = cfg.gui.enable;
      };
    };

    xdg.portal = {
      enable = cfg.gui.enable;
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

    fonts.fontconfig.enable = cfg.gui.enable;

    # window manager
    wayland.windowManager.sway = {
      package = (config.lib.nixGL.wrap pkgs.sway);
      enable = cfg.gui.enable;
      systemd.enable = true;
      systemd.xdgAutostart = true;
    };
  };
}
