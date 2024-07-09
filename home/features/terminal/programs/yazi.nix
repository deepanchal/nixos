{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: let
  catppuccin-yazi = inputs.catppuccin-yazi;
  catppuccin-bat = inputs.catppuccin-bat;
  flavor = config.theme.flavor;
in {
  home.packages = [
    pkgs.exiftool
    # https://yazi-rs.github.io/docs/quick-start#shell-wrapper
    (pkgs.writeShellScriptBin "f" ''
      set -ue -o pipefail

      function f() {
	      local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	      yazi "$@" --cwd-file="$tmp"
	      if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		      cd -- "$cwd"
	      fi
	      rm -f -- "$tmp"
      }

      f "$@"
    '')
  ];
  xdg.configFile."yazi/Catppuccin-${lib.toLower flavor}.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin ${flavor}.tmTheme";

  programs.yazi = {
    enable = true;
    theme = lib.importTOML "${catppuccin-yazi}/themes/${lib.toLower flavor}.toml";
    settings = {
      manager = {
        layout = [1 4 3];
        sort_by = "alphabetical";
        sort_sensitive = true;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_hidden = true;
        show_symlink = true;
      };
      preview = {
        tab_size = 2;
        # max_width = 600;
        # max_height = 900;
        # cache_dir = "${config.xdg.cacheHome}/yazi";
      };
    };
    keymap = {
      manager.append_keymap = [
        {
          on = ["d"];
          run = [
            "escape --visual"
            ''shell --confirm 'trashy put "$@"' ''
          ];
        }
      ];
    };
  };
}
