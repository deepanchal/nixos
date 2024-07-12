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
  ];
  xdg.configFile."yazi/Catppuccin-${lib.toLower flavor}.tmTheme".source = "${catppuccin-bat}/themes/Catppuccin ${flavor}.tmTheme";

  programs.yazi = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;

    theme = lib.importTOML "${catppuccin-yazi}/themes/${lib.toLower flavor}.toml";
    # Launches yazi and drops in current dir on exit
    # See: https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
    shellWrapperName = "f";
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
      manager.prepend_keymap = [
        {
          on = ["d"];
          run = [
            "escape --visual"
            ''shell --confirm 'trashy put "$@"' ''
          ];
        }
        {
          on = ["<C-s>"];
          run = "shell \"$SHELL\" --block --confirm";
          desc = "Open shell here";
        }
      ];
      input.prepend_keymap = [
        {
          on = ["<Esc>"];
          run = "close";
          desc = "Cancel input";
        }
      ];
    };
  };
}
