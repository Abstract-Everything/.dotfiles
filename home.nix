{ config, pkgs, ... }:

{
  home = {
    # This value determines the Home Manager release that your
    # configuration is compatible with. This helps avoid breakage
    # when a new Home Manager release introduces backwards
    # incompatible changes.
    #
    # You can update Home Manager without changing this value. See
    # the Home Manager release notes for a list of state version
    # changes in each release.
    stateVersion = "24.11";

    username = "jon";
    homeDirectory = "/home/jon";

    packages = with pkgs; [
      # terminal tools
      ripgrep
      fd
      unzip

      # region neovim tools
      tree-sitter

      ## bash
      bash-language-server
      shfmt

      ## c/ cpp
      clang-tools
      cmake-lint
      neocmakelsp

      ## c/ cpp/ rust/ zig
      vscode-extensions.vadimcn.vscode-lldb

      ## rust
      rust-analyzer

      ## zig
      zls

      ## gdscript
      gdtoolkit_4

      ## json
      nodePackages.vscode-json-languageserver

      ## yaml
      yaml-language-server

      ## lua
      lua-language-server
      selene
      stylua

      ## python
      mypy
      pyright
      ruff
      python313Packages.debugpy

      ## nix
      nil
      nixpkgs-fmt

      ## javascript
      typescript-language-server
      prettierd
      # endregion

      # other tools
      inotify-tools
      vim # for rvim

      # graphical tools
      (config.lib.nixGL.wrap ghostty)
      (config.lib.nixGL.wrap waybar)
      (config.lib.nixGL.wrap qutebrowser)
      dunst
      wl-clipboard
    ];
  };

  xdg.configFile.nvim = {
    enable = true;
    recursive = true;
    source = ./config/nvim;
  };

  xdg.configFile.ghostty = {
    enable = true;
    recursive = true;
    source = ./config/ghostty;
  };

  xdg.configFile.sway = {
    enable = true;
    recursive = true;
    source = ./config/sway;
  };

  xdg.configFile.waybar = {
    enable = true;
    recursive = true;
    source = ./config/waybar;
  };

  xdg.configFile.dunst = {
    enable = true;
    recursive = true;
    source = ./config/dunst;
  };

  programs = {
    # Let Home Manager install and manage itself.
    home-manager.enable = true;

    # shell
    zsh = {
      enable = true;
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
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # IDE
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # PDF viewer
    zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-keephue = true;
      };
    };

    wofi = {
      enable = true;
      package = (config.lib.nixGL.wrap pkgs.wofi);
    };
  };

  xdg.portal = {
    enable = true;
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
    enable = true;
    systemd.enable = true;
    systemd.xdgAutostart = true;
  };
}
