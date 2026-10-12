{
  config,
  pkgs,
  inputs,
  ...
}:
let
in
{
  nixpkgs.overlays = [
    inputs.claude-code-nix.overlays.default
  ];

  home.packages = [
    pkgs.claude-code
    (pkgs.writeShellApplication {
      name = "cg";
      runtimeInputs = [
        pkgs.dtach
        pkgs.coreutils
      ];
      text = ''
        apps=(claude lazygit nvim)
        id=$(printf %s "$PWD" | sha1sum | cut -c1-16)

        socket_for() {
          echo "''${XDG_RUNTIME_DIR:-/tmp}/cg-$id-$1.sock"
        }

        attach_with_redraw() {
          local socket=$1
          shift
          local terminal rows
          terminal=$(tty)
          rows=$(stty size | cut -d' ' -f1)
          stty rows $((rows - 1))
          (sleep 0.2 && stty -F "$terminal" rows "$rows") &
          dtach -A "$socket" -r winch -z "$@"
        }

        current=0
        while true; do
          app=''${apps[current]}
          command=("$app")
          if ((current == 0)); then
            command+=("$@")
          fi
          attach_with_redraw "$(socket_for "$app")" "''${command[@]}"
          if ((current == 0)) && [[ ! -S $(socket_for "$app") ]]; then
            break
          fi
          current=$(((current + 1) % ''${#apps[@]}))
        done

        for app in "''${apps[@]:1}"; do
          socket=$(socket_for "$app")
          if [[ -S $socket ]]; then
            attach_with_redraw "$socket" -E "$app"
          fi
        done
      '';
    })
  ];

  # Claude Code reads ~/.claude/CLAUDE.md — point it at the generic AGENTS.md.
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/AGENTS.md";
}
