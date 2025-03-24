{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  isWayland = config.wayland.windowManager.hyprland.enable;
  copy-cmd =
    if isWayland
    then "wl-copy"
    else "xclip -selection clipboard";
  paste-cmd =
    if isWayland
    then "wl-paste"
    else "xclip -selection clipboard -o";
in {
  config = {
    home.packages = [
      (pkgs.writeShellScriptBin "glsc" ''
        if [[ "$1" == "--help" ]]; then
          echo "Usage: glsc <total_commits> <author_name>"
          echo "Example: glsc 200 \"John Doe\""
          echo "Prints a list of git commits grouped by date in reverse order, optionally filtered by author."
          exit 0
        fi
        previous_date=""
        num_commits=''${1:-100}
        author=''${2:-""}
        git_command="git --no-pager log --no-merges --reverse --pretty=format:'%ad%n- %s (%h)' --date=format:'%Y-%m-%d' -n $num_commits"
        if [[ -n "$author" ]]; then
          git_command+=" --author=\"$author\""
        fi
        eval $git_command | while IFS= read -r line
        do
          if [[ $line != -* ]]; then
            if [[ $line != $previous_date ]]; then
              echo -e "\n\033[1;34m$line\033[0m\n"  # Print date in blue
              previous_date=$line
            fi
          else
            echo -e "\033[0;32m$line\033[0m"  # Print commit message in green
          fi
        done
      '')
    ];

    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        custom = "${config.xdg.configHome}/oh-my-zsh";
        plugins = [
          "archlinux" # archlinux completions / helpers
          "asdf" # asdf completions
          "aws" # aws completions
          "colored-man-pages" # colorize man pages
          "common-aliases" # common-aliases for ls, file-handling, find, etc.
          "copybuffer" # binds ctrl-o to copy currently typed cmd
          "docker" # docker aliases
          "docker-compose" # docker-compose aliases
          "dnote" # auto-completion for Dnote, a simple command line notebook
          "flutter" # flutter
          "fancy-ctrl-z" # ctrl-z opens/closes vim
          "fzf" # fzf autocompletions & bindings
          "gh" # github cli
          "git" # git alias/completions
          "git-extras" # awesome git scripts
          "gitfast" # faster git
          "gpg-agent" # enables gpg agent if not running
          "helm" # helm autocompletions
          "heroku" # heroku autocompletions
          "httpie" # httpie autocompletions
          "kubectl" # kubectl completions/aliases
          "minikube" # minikube completions
          "npm" # npm aliases
          # "pnpm" # pnpm aliases (custom: https://github.com/ntnyq/omz-plugin-pnpm)
          "poetry" # python poetry autocompletions
          # "projen" # projen autocompletions (custom: mkdir -p $ZSH_CUSTOM/plugins/projen && projen completion > $ZSH_CUSTOM/plugins/projen/_projen)
          "python" # python aliases
          "rust" # rust autocompletions
          "rsync" # rsync aliases
          "mise" # mise (asdf clone) completions
          "systemd" # systemd aliases
          # "systemadmin" # aliases/functions to make system admin's life easier
          "taskwarrior" # taskwarrior autocompletions
          # "timewarrior" # timewarrior completions/aliases (custom: https://github.com/svenXY/timewarrior)
          "tmux" # tmux completions/aliases
          "urltools" # urlencode and urldecode strings
          # "yarn" # yarn completions/aliases
          "zoxide" # initializes zoxide (smart cd with 'z')
          # "zsh-autosuggestions" # zsh auto suggestions
          "zsh-interactive-cd" # interactive tab completion for cd
          # "zsh-navigation-tools" # set of zsh nav tools (n-history, n-cd, n-kill, n-list)
          # "zsh-syntax-highlighting"       # zsh syntax highlighting !! must be last
          # "fast-syntax-highlighting" # https://github.com/zdharma-continuum/fast-syntax-highlighting
          # Zsh vi mode
          # Use ESC or CTRL-[ to enter Normal mode.
          "vi-mode" # https://github.com/ohmyzsh/ohmyzsh/blob/899af6328b395f1db2e74d09880a1af435a188ca/plugins/vi-mode/README.md
        ];

        extraConfig =
          # sh
          ''
            # Uncomment the following line if you want to disable marking untracked files
            # under VCS as dirty. This makes repository status check for large repositories
            # much, much faster.
            DISABLE_UNTRACKED_FILES_DIRTY="true"

            # Key bind for zsh-autosuggestions
            bindkey '^ ' autosuggest-accept

            # Enable option stacking for docker
            # Example: docker run -it <TAB> doesn't work, because you're stacking the -i and -t options
            # See: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
            zstyle ':completion:*:*:docker:*' option-stacking yes
            zstyle ':completion:*:*:docker-*:*' option-stacking yes

            # Hook mise (asdf rust clone) to shell
            # eval "$(mise activate zsh)"

            # A shortcut for mise managed direnv.
            # mise exec direnv@latest -- direnv
            # direnv() { mise exec direnv@latest -- direnv "$@"; }

            # Load secret env vars
            [ -f ~/scripts/load-secret-env-vars.sh ] && source ~/scripts/load-secret-env-vars.sh
          '';
      };

      initExtraFirst =
        # sh
        ''
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';

      envExtra =
        # sh
        ''
          # Cargo binaries
          export PATH=$PATH:~/.cargo/bin

          # Android Env
          #export ANDROID_SDK_ROOT=/opt/android-sdk
          export ANDROID_SDK_ROOT=$HOME/Android/Sdk
          export ANDROID_HOME=$HOME/Android/Sdk
          export PATH=$PATH:~/.android/avd
          export PATH=$PATH:$ANDROID_HOME/emulator
          export PATH=$PATH:$ANDROID_HOME/tools
          export PATH=$PATH:$ANDROID_HOME/tools/bin
          export PATH=$PATH:$ANDROID_HOME/platform-tools
          export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
          export ANDROID_NDK=$ANDROID_HOME/ndk-bundle
          export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable

          # PNPM
          export PNPM_HOME="$HOME/.local/share/pnpm"
          export PATH="$PATH:$PNPM_HOME"
        '';

      history = {
        # share history between different zsh sessions
        share = true;

        # saves timestamps to the histfile
        extended = true;

        # optimize size of the histfile by avoiding duplicates
        # or commands we don't need remembered
        save = 1000000000;
        size = 1000000000;
        expireDuplicatesFirst = true;
        ignoreDups = true;
        ignoreSpace = true;
        ignorePatterns = ["rm *" "pkill *" "kill *" "killall *"];
      };

      shellAliases = {
        # Replacements
        ls = "eza -l --icons --color always";
        ll = "eza -l --icons --color always";
        la = "eza -alughHo --git --icons --color always";
        cat = "bat --pager=never --plain";
        grep = "rg";
        ps = "procs";
        tail = "tspin";

        # Remove this annoying fd alias coming from maybe common-aliases plugin or hm fd module
        # fd: aliased to fd '--hidden' '--no-ignore' '--no-absolute-path'
        # https://github.com/ohmyzsh/ohmyzsh/issues/9414#issuecomment-734947141
        fd = lib.mkForce "fd";

        # Other apps
        zj = "zellij";

        # IP Aliases
        myip = "ip addr | grep -m 1 -o '192.*.*.*' | cut -d '/' -f 1";
        wanip = "curl -s -X GET https://checkip.amazonaws.com";

        # Copy / Paste
        pbcopy = "${copy-cmd}";
        pbpaste = "${paste-cmd}";

        # Devops
        mk = "minikube";
        kctx = "kubectx";
        kctl = "kubectl";
        kspy = "kubespy";
        kevents = "k get events --sort-by=.metadata.creationTimestamp";
        docker_clean_images = "docker rmi $(docker images -a --filter=dangling=true -q)";
        docker_clean_ps = "docker rm $(docker ps --filter=status=exited --filter=status=created -q)";

        # Nix specific aliases
        cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
        bloat = "nix path-info -Sh /run/current-system";
        curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
        gc-check = "nix-store --gc --print-roots | egrep -v \"^(/nix/var|/run/\w+-system|\{memory|/proc)\"";
        repair = "nix-store --verify --check-contents --repair";
        run = "nix run";
        search = "nix search";
        shell = "nix shell";
        build = "nix build $@ --builders \"\"";

        # Git
        lg = "lazygit";
        g = "git";
        gls = "git --no-pager log --no-merges --reverse --pretty=format:'- %s (%h)' -n 100 && echo";
        gcmsgn = "git commit --no-verify --message";
        glscommits = "git log --no-merges --count HEAD ^$(git_main_branch) --reverse --pretty=format:%s | sed 's/^/- /'";

        # Other
        c = "clear";
        rm = "rm -i";
        cp = "cp -i";
        mv = "mv -i";
        dallow = "direnv allow";
        sysinfo = "inxi -Fxxxz";
        errors = "journalctl -b -p err | less";

        # https://wiki.nixos.org/wiki/WireGuard#Client_setup_(non-declaratively)
        wg-on = "systemctl start wg-quick-wg0.service";
        wg-off = "systemctl stop wg-quick-wg0.service";

        pj = "projen";
        min = "mise install";
      };

      shellGlobalAliases = {
        CP = "| ${copy-cmd}";
        JQ = "| jq";
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.zsh-fast-syntax-highlighting;
          file = "share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh";
        }
        {
          name = "pnpm";
          src = inputs.zsh-omz-plugin-pnpm;
          file = "pnpm.plugin.zsh";
        }
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "p10k-config";
          src = lib.cleanSource ./p10k;
          file = "p10k.zsh";
        }
        {
          name = "p10k-mise-config";
          src = lib.cleanSource ./p10k;
          file = "p10k.mise.zsh";
        }
      ];
    };
  };
}
