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
      // mkToolsOption "luau"
      // mkToolsOption "python"
      // mkToolsOption "nix"
      // mkToolsOption "javascript_typescript";
  });

  guiModule = types.submodule ({ config, ... }: {
    options = {
      enable = mkEnableOption "tools which require graphics backend";
      desktopEnvironment = {
        enable = mkEnableOption "desktop environment";
        modifier = mkOption {
          default = "Mod4";
          description = "Include ${language} tools";
          type = types.enum [ "Mod2" "Mod3" "Mod4" "Mod5" ];
        };
      };
    }
    // mkToolsOption "3d"
    // mkToolsOption "2d"
    // mkToolsOption "social";
  });

  shellScriptFromLocalBin = file: (
    pkgs.writeShellScriptBin
      "${file}"
      (builtins.readFile ./local/bin/${file})
  );

  fzfCommonOptions = " --hidden " + concatMapStringsSep " " (dir: " --exclude ${dir}") [ ".git" ];

  swayVariables =
    rec {
      mod = cfg.gui.desktopEnvironment.modifier;
      windowMod = mod;
      commandMod = mod + "+Control";
      launchMod = mod + "+Alt";
      terminal = "ghostty";
      left = "h";
      down = "j";
      up = "k";
      right = "l";

      homeMonitor = "Samsung Electric Company U28E590 HTPJ907067";

      switchWs = key: ws: {
        "${windowMod}+${toString key}" = "workspace number ${toString ws}";
      };

      moveContainerToWs = key: ws: {
        "${windowMod}+Shift+${toString key}" = "move container to workspace number ${toString ws}";
      };

      modeToString = mode: builtins.toJSON config.wayland.windowManager.sway.config.modes."${mode}";

      switchMode = mode: ''mode ${mode}; exec notify-send "Activated sway mode" "$(echo '${modeToString mode}' | jq)"'';
    };
in
{
  options = {
    dotfiles = {
      enable = mkEnableOption "Jonathan's dotfiles";

      email = mkOption {
        default = "jon.d.cam@gmail.com";
        description = "Email address for the user";
        type = types.str;
      };

      shell-tools = mkOption {
        default = false;
        description = "Include tools mostly used from the terminal";
        type = types.bool;
      };

      ssh = mkOption {
        default = false;
        description = "Include ssh-agent config";
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
      packages = (with pkgs;
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
          # json processing
          jq

          (shellScriptFromLocalBin "git-change-branch")
          (shellScriptFromLocalBin "git-clean-branches")
          (shellScriptFromLocalBin "git-commit-fuzzy-fixup")
          (shellScriptFromLocalBin "git-fetch-and-checkout-head")
          (shellScriptFromLocalBin "git-first-branch-commit")
          (shellScriptFromLocalBin "git-rebase-select-branch")
          (shellScriptFromLocalBin "git-rebase-squash")
          (shellScriptFromLocalBin "git-select-branch")
          (shellScriptFromLocalBin "git-select-commit")
        ]
        ++ optionals cfg.neovim.enable (
          [ tree-sitter ]
          ++ optionals cfg.neovim.bash [
            bash-language-server
            shfmt
          ]
          ++ optionals cfg.neovim.cmake [
            cmake
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
          ]
          ++ optionals (cfg.neovim.lua || cfg.neovim.luau) [
            selene
            stylua
          ]
          ++ optionals cfg.neovim.luau [
            rojo
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
        ++ optionals cfg.gui.desktopEnvironment.enable (
          [
            # taskbar
            (config.lib.nixGL.wrap waybar)
            # screenshot
            (config.lib.nixGL.wrap grim)
            (config.lib.nixGL.wrap slurp)
            (config.lib.nixGL.wrap swappy)
            # screen recording
            wf-recorder
            # polkit agent
            (config.lib.nixGL.wrap kdePackages.polkit-kde-agent-1)
            # notification
            libnotify
            # clipboard
            wl-clipboard
            # screen power on/ off
            swayidle

            (shellScriptFromLocalBin "wm-exit")
            (shellScriptFromLocalBin "wm-screenshot-select-area")
            (shellScriptFromLocalBin "wm-screenshot-window")
            (shellScriptFromLocalBin "single-output-per-monitor")
            (shellScriptFromLocalBin "mute-spotify-on-advertisement")

          ]
          ++ [
            # browser
            (config.lib.nixGL.wrap pkgs.qutebrowser)
            # fonts
            noto-fonts
            noto-fonts-lgc-plus
            noto-fonts-cjk-sans
            noto-fonts-cjk-serif
            noto-fonts-color-emoji
            noto-fonts-monochrome-emoji
            nerd-fonts.noto
          ]
          ++ optionals cfg.gui."3d" [
            (config.lib.nixGL.wrap blender-hip)
          ]
          ++ optionals cfg.gui."2d" [
            (config.lib.nixGL.wrap krita)
          ]
          ++ optionals cfg.gui.social [
            (config.lib.nixGL.wrap signal-desktop)
            (config.lib.nixGL.wrap discord)
          ]
        )
      );

      sessionVariables = {
        LANG = "en_GB.UTF-8";
        LC_ALL = "en_GB.UTF-8";

        VISUAL = mkIf cfg.neovim.enable "nvim";
        PAGER = mkIf cfg.neovim.enable "nvim -R";
        MANPAGER = mkIf cfg.neovim.enable "nvim -c :Man!";
        SUDO_EDITOR = "rvim";
        BROWSER = mkIf cfg.gui.enable "qutebrowser";
      };
    };

    xdg.configFile.nvim = mkIf cfg.neovim.enable {
      enable = true;
      recursive = true;
      source = ./config/nvim;
    };

    xdg.configFile.swappy = mkIf cfg.gui.desktopEnvironment.enable {
      enable = true;
      recursive = true;
      source = ./config/swappy;
    };

    xdg.configFile.waybar = mkIf cfg.gui.desktopEnvironment.enable {
      enable = true;
      recursive = true;
      source = ./config/waybar;
    };

    xdg.configFile.qutebrowser = mkIf cfg.gui.enable {
      enable = true;
      recursive = true;
      source = ./config/qutebrowser;
    };

    programs = {
      # shell
      direnv = mkIf cfg.shell-tools {
        enable = true;
        enableBashIntegration = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };

      git = mkIf cfg.shell-tools {
        enable = true;
        userEmail = cfg.email;
        userName = "Jonathan Camilleri";
        aliases = {
          a = "add";
          ap = "add --patch";
          b = "branch";
          c = "commit";
          ca = "commit --amend";
          capp = "commit --amend --no-edit";
          cb = "!sh git-change-branch";
          cf = "!sh git-commit-fuzzy-fixup";
          clean-branches = "!sh git-clean-branches";
          co = "checkout";
          com = "!sh git-fetch-and-checkout-head";
          cop = "checkout --patch";
          cp = "cherry-pick";
          cpc = "cherry-pick --continue";
          d = "diff";
          da = "diff --staged";
          das = "diff --staged --stat";
          db = "diff origin...HEAD";
          dc = "show";
          ds = "diff --stat";
          dst = "diff stash@{0}";
          l = "log";
          lo = "log origin..HEAD";
          los = "log origin..HEAD --oneline";
          ls = "log --oneline";
          mc = "merge --continue";
          pcb = "push -u origin HEAD";
          r = "reset";
          rb = "rebase";
          rbb = "!sh git-rebase-select-branch";
          rbc = "rebase --continue";
          rbm = "rebase --interactive origin/HEAD";
          rbs = "!sh git-rebase-squash";
          rc = "reset --soft HEAD~";
          rp = "reset --patch";
          s = "status";
          st = "stash";
          stc = "stash show --patch";
          std = "stash drop";
          stl = "stash list";
        };
        extraConfig = {
          color = {
            pager = "no";
          };
          rebase = {
            autostash = true;
          };
          advice = {
            detatchedHead = false;
          };
        };
      };

      zsh = mkIf cfg.shell-tools {
        enable = true;
        dotDir = ".config/zsh";
        syntaxHighlighting.enable = true;
        autosuggestion.enable = true;
        autocd = true;
        enableCompletion = true;
        initContent = lib.mkMerge [
          (lib.mkOrder 500 ''
            HYPHEN_INSENSITIVE="true"
            COMPLETION_WAITING_DOTS="true"
          '')
          (lib.mkOrder 1000 ''
            bindkey '^ ' autosuggest-accept

            # Allows fuzzy matching of completions in the presence of typos
            zstyle ':completion:*' completer _complete _match _approximate
            zstyle ':completion:*:match:*' original only
            zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'

            # Do not suggest the ./ and ../$(current-directory)
            zstyle ':completion:*:cd:*' ignore-parents parent pwd
          '')
        ];
        shellAliases = {
          g = "git";
          updatedb = "updatedb --require-visibility 0 -o $HOME/.cache/locate.db";
          locate = "locate --database=$HOME/.cache/locate.db";
        };
        oh-my-zsh = {
          enable = true;
          theme = "af-magic";
          plugins = [ "vi-mode" "command-not-found" ];
          extraConfig = ''
            DISABLE_UNTRACKED_FILES_DIRTY="true"
          '';
        };
      };

      fzf = mkIf cfg.shell-tools {
        enable = true;
        enableZshIntegration = true;
        changeDirWidgetCommand = "fd --type d" + fzfCommonOptions;
        defaultCommand = "fd --type f" + fzfCommonOptions;
        fileWidgetCommand = "fd --type f" + fzfCommonOptions;
      };

      zoxide = mkIf cfg.shell-tools {
        enable = true;
        enableZshIntegration = true;
      };

      ssh = mkIf cfg.ssh {
        enable = true;
        addKeysToAgent = "yes";
        matchBlocks = {
          "github.com" =
            {
              identityFile = "~/.ssh/github";
              identitiesOnly = true;
            };
          "bitbucket.org" = {
            identityFile = "~/.ssh/bitbucket";
            identitiesOnly = true;
          };
        };
      };

      # IDE
      neovim = mkIf cfg.neovim.enable {
        enable = true;
        defaultEditor = true;
      };

      # gui
      ghostty = mkIf cfg.gui.enable {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.ghostty);
        settings = { window-decoration = false; };
      };

      wofi = mkIf cfg.gui.desktopEnvironment.enable {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.wofi);
      };

      waybar = mkIf cfg.gui.desktopEnvironment.enable {
        enable = false; # We start it explicitly
        package = (config.lib.nixGL.wrap pkgs.waybar);
      };

      mpv = mkIf cfg.gui.enable {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.mpv);
      };

      zathura = mkIf cfg.gui.enable {
        enable = true;
        options = {
          recolor = true;
          recolor-keephue = true;
        };
      };

      swaylock = mkIf cfg.gui.desktopEnvironment.enable {
        enable = true;
      };
    };

    services = {
      ssh-agent = mkIf cfg.ssh {
        enable = true;
      };

      dunst = mkIf cfg.gui.desktopEnvironment.enable {
        enable = true;
        settings = {
          global = {
            markup = true;
            dmenu = "wofi -d menu -p dunst";
            word_wrap = true;
          };
        };
      };

      swayidle = mkIf cfg.gui.desktopEnvironment.enable {
        enable = true;
        timeouts = [
          {
            timeout = 300;
            command = "swaymsg output \"*\" power off";
            resumeCommand = "swaymsg output \"*\" power on";
          }
          {
            timeout = 310;
            command = "wm-exit lock";
          }
        ];
        events = [
          {
            event = "before-sleep";
            command = "wm-exit lock";
          }
          {
            event = "lock";
            command = "wm-exit lock";
          }
        ];
      };
    };

    xdg.portal = mkIf cfg.gui.desktopEnvironment.enable {
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

    fonts = mkIf cfg.gui.enable {
      fontconfig.enable = true;
    };

    # window manager
    wayland = {
      windowManager.sway = mkIf cfg.gui.desktopEnvironment.enable {
        enable = true;
        package = (config.lib.nixGL.wrap pkgs.sway);
        checkConfig = true;
        config = {
          modifier = cfg.gui.desktopEnvironment.modifier;

          defaultWorkspace = "workspace number 1";
          workspaceLayout = "default";
          workspaceAutoBackAndForth = true;

          input."*"."xkb_layout" = "gb";

          output."${swayVariables.homeMonitor}".scale = "1.20";

          window = {
            border = 1;
            titlebar = false;
            hideEdgeBorders = "none";
            commands = [
              {
                command = "inhibit_idle focus";
                criteria = {
                  class = "discord";
                };
              }
              {
                command = "floating off";
                criteria = {
                  title = "Blender File View";
                };
              }
            ];
          };

          floating = {
            border = 1;
            titlebar = false;
            modifier = swayVariables.mod;
          };

          focus = {
            wrapping = "no";
            followMouse = true;
            newWindow = "urgent";
            mouseWarping = "output";
          };

          colors = {
            focused = {
              border = "#02bedd";
              background = "#333333";
              text = "#ffffff";
              indicator = "#ffffff";
              childBorder = "#02bedd";
            };
            focusedInactive = {
              border = "#000000";
              background = "#333333";
              text = "#ffffff";
              indicator = "#000000";
              childBorder = "#000000";
            };
          };

          startup = [
            {
              command = "single-output-per-monitor";
              always = true;
            }
            {
              command = "mute-spotify-on-advertisement";
              always = true;
            }
            {
              command = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
            }
            {
              command = "${config.programs.waybar.package}/bin/waybar";
            }
          ];

          modes = {
            resize = {
              "h" = "resize grow height 2 ppt";
              "Shift+h" = "resize shrink height 2 ppt";
              "w" = "resize grow width 2 ppt";
              "Shift+w" = "resize shrink width 2 ppt";
              "Escape" = "mode default";
              "Return" = "mode default";
            };

            session = {
              "l" = "exec --no-startup-id wm-exit lock, mode default";
              "e" = "exec --no-startup-id wm-exit logout, mode default";
              "s" = "exec --no-startup-id wm-exit suspend, mode default";
              "h" = "exec --no-startup-id wm-exit hibernate, mode default";
              "r" = "exec --no-startup-id wm-exit reboot, mode default";
              "p" = "exec --no-startup-id wm-exit poweroff, mode default";
              "Escape" = "mode default";
              "Return" = "mode default";
            };
          };

          keybindings = with swayVariables;
            (switchWs 1 1) //
            (switchWs 2 2) //
            (switchWs 3 3) //
            (switchWs 4 4) //
            (switchWs 5 5) //
            (switchWs 6 6) //
            (switchWs 7 7) //
            (switchWs 8 8) //
            (switchWs 9 9) //
            (switchWs 0 10) //
            {
              "${windowMod}+Minus" = "scratchpad show";
            } //
            (moveContainerToWs 1 1) //
            (moveContainerToWs 2 2) //
            (moveContainerToWs 3 3) //
            (moveContainerToWs 4 4) //
            (moveContainerToWs 5 5) //
            (moveContainerToWs 6 6) //
            (moveContainerToWs 7 7) //
            (moveContainerToWs 8 8) //
            (moveContainerToWs 9 9) //
            (moveContainerToWs 0 10) //
            { "${windowMod}+Shift+Minus" = "move scratchpad"; } //
            {
              "${windowMod}+${left}" = "focus left";
              "${windowMod}+${down}" = "focus down";
              "${windowMod}+${up}" = "focus up";
              "${windowMod}+${right}" = "focus right";
              "${windowMod}+a" = "focus parent";
              "${windowMod}+Shift+Space" = "focus mode_toggle";
            } //
            {
              "${windowMod}+Shift+${left}" = "move left";
              "${windowMod}+Shift+${down}" = "move down";
              "${windowMod}+Shift+${up}" = "move up";
              "${windowMod}+Shift+${right}" = "move right";
            } //
            {
              "${windowMod}+q" = "kill";
              "${windowMod}+f" = "fullscreen toggle";
              "${windowMod}+t" = "floating toggle";
              "${windowMod}+r" = switchMode "resize";
            } //
            {
              "${windowMod}+s" = "layout stacking";
              "${windowMod}+w" = "layout tabbed";
              "${windowMod}+x" = "split vertical;exec notify-send 'tile vertically'";
              "${windowMod}+v" = "split horizontal;exec notify-send 'tile horizontally'";
            } //
            {
              "${commandMod}+r" = "reload";
              "${commandMod}+Shift+r" = "restart";
              "${commandMod}+p" = "exec --no-startup-id wm-screenshot-select-area";
              "${commandMod}+Shift+p" = "exec --no-startup-id wm-screenshot-window";
              "${commandMod}+s" = "output \"${homeMonitor}\" scale 1.20";
              "${commandMod}+Shift+s" = "output \"${homeMonitor}\" scale 2.25";
              "${commandMod}+e" = switchMode "session";
            } //
            {
              "${launchMod}+Space" = "exec --no-startup-id wofi --show=drun --insensitive --allow-images";
              "${launchMod}+d" = "exec --no-startup-id discord";
              "${launchMod}+s" = "exec --no-startup-id spotify-launcher";
              "${launchMod}+q" = "exec --no-startup-id qutebrowser";
              "${launchMod}+i" = "exec --no-startup-id qutebrowser --temp-basedir";
              "${launchMod}+Return" = "exec --no-startup-id ${terminal}";
            };

          assigns = {
            "2" = [
              { app_id = "^looking-glass-client$"; }
            ];
            "8" = [
              { class = "^discord$"; }
              { class = "^Signal$"; }
            ];
            "9" = [
              { class = "^Spotify$"; }
            ];
          };

          bars = [ ];
        };
      };
    };
  };
}
