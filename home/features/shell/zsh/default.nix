{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
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
          "adb" # adb completions
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
          "ripgrep" # ripgrep autocompletions
          "rust" # rust autocompletions
          "rsync" # rsync aliases
          "rtx" # rtx (asdf clone) completions
          "systemd" # systemd aliases
          "systemadmin" # aliases/functions to make system admin's life easier
          "taskwarrior" # taskwarrior autocompletions
          # "timewarrior" # timewarrior completions/aliases (custom: https://github.com/svenXY/timewarrior)
          "tmux" # tmux completions/aliases
          "urltools" # urlencode and urldecode strings
          "yarn" # yarn completions/aliases
          "zoxide" # initializes zoxide (smart cd with 'z')
          # "zsh-autosuggestions" # zsh auto suggestions
          "zsh-interactive-cd" # interactive tab completion for cd
          "zsh-navigation-tools" # set of zsh nav tools (n-history, n-cd, n-kill, n-list)
          # "zsh-syntax-highlighting"       # zsh syntax highlighting !! must be last
          # "fast-syntax-highlighting" # https://github.com/zdharma-continuum/fast-syntax-highlighting
        ];

        extraConfig = ''
          # Key bind for zsh-autosuggestions
          bindkey '^ ' autosuggest-accept

          # Enable option stacking for docker
          # Example: docker run -it <TAB> doesn't work, because you're stacking the -i and -t options
          # See: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker
          zstyle ':completion:*:*:docker:*' option-stacking yes
          zstyle ':completion:*:*:docker-*:*' option-stacking yes
        '';
      };

      initExtraFirst = ''
        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
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
