{ config, pkgs, nixgl, ... }:

{
  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = [ "mesa" ];

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
      # terminal
      (config.lib.nixGL.wrapOffload ghostty)

      # terminal tools
      ripgrep
      fd
      unzip

      # neovim tools
      tree-sitter

      # other tools
      inotify-tools
      vim # for rvim
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

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-keephue = true;
      };
    };
  };
}
