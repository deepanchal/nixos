{
  config,
  pkgs,
  lib,
  ...
}:
let
  isWayland = config.wayland.windowManager.hyprland.enable;
  copy-cmd = if isWayland then "wl-copy" else "xclip -selection clipboard";
  paste-cmd = if isWayland then "wl-paste" else "xclip -selection clipboard -o";
in
{
  imports = [
    ./bun.nix
    ./docker-compose.nix
    ./docker.nix
    ./flutter.nix
    ./git.nix
    ./pnpm.nix
    ./systemd.nix
  ];

  programs.fish = {
    enable = true;

    shellAliases = {
      # Replacements
      ls = "eza -l --icons --color always";
      ll = "eza -l --icons --color always";
      la = "eza -alughHo --git --icons --color always";
      cat = "bat --pager=never --plain";
      grep = "rg";
      ps = "procs";

      fd = lib.mkForce "fd";

      # Other apps
      zj = "zellij";

      # IP
      myip = "ip addr | grep -m 1 -o '192.*.*.*' | cut -d '/' -f 1";
      wanip = "curl -s -X GET https://checkip.amazonaws.com";

      # Copy / Paste
      pbcopy = copy-cmd;
      pbpaste = paste-cmd;

      # Nix
      cleanup = "sudo nix-collect-garbage --delete-older-than 3d && nix-collect-garbage -d";
      bloat = "nix path-info -Sh /run/current-system";
      curgen = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
      repair = "nix-store --verify --check-contents --repair";
      run = "nix run";
      search = "nix search";
      shell = "nix shell";

      # AI
      ai = "aichat --session";
      aish = "aichat -c -r %shell%";
      aiquick = "aichat --model openai:gpt-5-mini --session";
      aireason = "aichat --model openai:o3 --session";

      # Other
      c = "clear";
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      sysinfo = "inxi -Fxxxz";
      errors = "journalctl -b -p err | less";

      wg-on = "systemctl start wg-quick-wg0.service";
      wg-off = "systemctl stop wg-quick-wg0.service";

      bt-on = "bluetoothctl power on";
      bt-off = "bluetoothctl power off";
      bt-connect = "bluetoothctl connect $HEADPHONES_MAC";
      bt-disconnect = "bluetoothctl disconnect $HEADPHONES_MAC";
    };

    # Abbreviations expand inline when you press space
    # commands so you see what's actually being run.
    shellAbbrs = {
      lg = "lazygit";
      min = "mise install";
      dallow = "direnv allow";
    };

    functions = {
      docker_clean_images = "docker rmi (docker images -a --filter=dangling=true -q)";
      docker_clean_ps = "docker rm (docker ps --filter=status=exited --filter=status=created -q)";

      gc-check = ''
        nix-store --gc --print-roots \
          | string match -rv '^(/nix/var|/run/\w+-system|\{memory|/proc)'
      '';

      build = ''nix build $argv --builders ""'';

      glscommits = ''
        set -l main_branch (git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
        test -z "$main_branch"; and set main_branch main
        git log --no-merges HEAD "^$main_branch" --reverse --pretty=format:%s | sed 's/^/- /'
      '';

      # Insert system clipboard contents at cursor without the trailing-newline
      # bug in fish_clipboard_paste/__fish_paste, which splits on \n and re-joins
      # an empty trailing element when clipboard data ends with a newline (which
      # fish_clipboard_copy can leave behind for some content).
      fish_vi_paste = ''
        set -l data (${paste-cmd} 2>/dev/null | string collect | string replace -r '\n+$' "")
        test -z "$data"; and return
        commandline -i -- $data
      '';

      # Replace the current vi visual selection with system clipboard contents.
      fish_vi_visual_paste = ''
        commandline -f kill-selection end-selection
        fish_vi_paste
        commandline -f repaint-mode
      '';
    };

    # Env / PATH (mirrors zsh envExtra).
    shellInit = ''
      # Cargo / Go
      fish_add_path -ga $HOME/.cargo/bin
      fish_add_path -ga $HOME/go/bin

      # Android
      set -gx ANDROID_SDK_ROOT $HOME/Android/Sdk
      set -gx ANDROID_HOME $HOME/Android/Sdk
      set -gx ANDROID_NDK $ANDROID_HOME/ndk-bundle
      set -gx CHROME_EXECUTABLE /usr/bin/google-chrome-stable
      fish_add_path -ga $HOME/.android/avd
      fish_add_path -ga $ANDROID_HOME/emulator
      fish_add_path -ga $ANDROID_HOME/tools
      fish_add_path -ga $ANDROID_HOME/tools/bin
      fish_add_path -ga $ANDROID_HOME/platform-tools
      fish_add_path -ga $ANDROID_HOME/cmdline-tools/latest/bin

      # PNPM
      set -gx PNPM_HOME $HOME/.local/share/pnpm
      fish_add_path -ga $PNPM_HOME

      # Dart
      set -gx DART_PUB_CACHE_BIN $HOME/.pub-cache/bin
      fish_add_path -ga $DART_PUB_CACHE_BIN
    '';

    interactiveShellInit = ''
      # Hybrid vi/emacs key bindings (modal editing + readline shortcuts)
      set -g fish_key_bindings fish_hybrid_key_bindings

      # Cursor shape per mode
      set -g fish_cursor_default block
      set -g fish_cursor_insert line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_visual block

      # vi mode: jk to exit insert mode (alongside Esc and Ctrl+[)
      bind -M insert -m default jk cancel repaint-mode

      # Ctrl+C preserves the typed command above the new prompt (zsh-like).
      # fish_hybrid_key_bindings binds this to clear-commandline, which wipes
      # the line entirely; cancel-commandline keeps it visible as reference.
      bind -M default ctrl-c cancel-commandline
      bind -M insert ctrl-c cancel-commandline

      # vi mode: route yank/paste through the system clipboard.
      # See: https://github.com/fish-shell/fish-shell/issues/4028
      bind -M default Y fish_clipboard_copy
      bind -M default yy fish_clipboard_copy
      bind -M visual -m default y 'fish_clipboard_copy; commandline -f end-selection repaint-mode'
      bind -M default p fish_vi_paste
      bind -M default P 'fish_vi_paste; commandline -f backward-char'
      bind -M visual -m default p fish_vi_visual_paste
      bind -M visual -m default P fish_vi_visual_paste

      # Ctrl + Space to accept auto-suggestion
      bind -M insert ctrl-space accept-autosuggestion
      bind ctrl-space accept-autosuggestion

      # Ctrl + O to copy current command line to clipboard
      bind -M insert ctrl-o fish_clipboard_copy
      bind ctrl-o fish_clipboard_copy

      # Disable the welcome banner
      set -g fish_greeting
    '';

    plugins = [
      # bass: run bash scripts inside fish
      {
        name = "bass";
        inherit (pkgs.fishPlugins.bass) src;
      }
    ];
  };
}
