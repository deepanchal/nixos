{
  pkgs,
  config,
  lib,
  ...
}:
let
  c = config.colorScheme.palette;
  # Using this overlay with latest version since it's not in nixpkgs yet
  televisionOverlay = final: prev: {
    television = prev.television.overrideAttrs (
      finalAttrs: _: {
        src = prev.fetchFromGitHub {
          owner = "alexpasmantier";
          repo = "television";
          rev = "4463579d1334cba031aeb8b3ccb2c718974ac6aa";
          sha256 = "sha256-ncaIZJ/XQTl2uIuFYVl+NJpADSH/0ce8YsJshyAJ5/I=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          inherit (finalAttrs) src;
          hash = "sha256-U0bgHU3RmW6v0AHy8LdVj3wjtcIr0y6ppPl/U++u4HY=";
        };
        doCheck = false;
      }
    );
  };
in
{
  nixpkgs.overlays = [ televisionOverlay ];
  home.packages = with pkgs; [
    bat
    fd
    ripgrep
    nix-search-tv
  ];
  programs.television = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    settings = {
      ui = {
        input_bar_position = "top";
        theme = "catppuccin";
      };
    };
  };

  xdg.configFile."television/cable".source = ./cable;

  # https://github.com/catppuccin/television/blob/d021b8c48bac87a30a408ec8cc154373b27eac0b/themes/catppuccin-mocha.toml
  # https://github.com/catppuccin/television/blob/main/themes/catppuccin-mocha.toml
  xdg.configFile."television/themes/catppuccin.toml" = {
    force = true;
    text =
      # toml
      ''
        # general
        background = "#${c.base}"
        border_fg = "#${c.overlay0}"
        text_fg = "#${c.text}"
        dimmed_text_fg = "#${c.overlay0}"

        # input
        input_text_fg = "#${c.red}"
        result_count_fg = "#${c.red}"

        # results
        result_name_fg = "#${c.blue}"
        result_line_number_fg = "#${c.yellow}"
        result_value_fg = "#${c.lavender}"
        selection_fg = "#${c.green}"
        selection_bg = "#${c.surface0}"
        match_fg = "#${c.red}"

        # preview
        preview_title_fg = "#${c.peach}"

        # modes
        channel_mode_fg = "#${c.base}"
        channel_mode_bg = "#${c.pink}"
        remote_control_mode_fg = "#${c.base}"
        remote_control_mode_bg = "#${c.green}"
        send_to_channel_mode_fg = "#${c.sky}"
      '';
  };
}
