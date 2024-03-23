{ config, pkgs, ... }:

let
  inherit (config) colorscheme;
  inherit (colorscheme) colors;
in
{
  programs.wezterm = {
    enable = true;
    # colorSchemes = {
    #   "${colorscheme.slug}" = {
    #     foreground = "#${colors.base05}";
    #     background = "#${colors.base00}";
    #
    #     ansi = [
    #       "#${colors.base08}"
    #       "#${colors.base09}"
    #       "#${colors.base0A}"
    #       "#${colors.base0B}"
    #       "#${colors.base0C}"
    #       "#${colors.base0D}"
    #       "#${colors.base0E}"
    #       "#${colors.base0F}"
    #     ];
    #     brights = [
    #       "#${colors.base00}"
    #       "#${colors.base01}"
    #       "#${colors.base02}"
    #       "#${colors.base03}"
    #       "#${colors.base04}"
    #       "#${colors.base05}"
    #       "#${colors.base06}"
    #       "#${colors.base07}"
    #     ];
    #     cursor_fg = "#${colors.base00}";
    #     cursor_bg = "#${colors.base05}";
    #     selection_fg = "#${colors.base00}";
    #     selection_bg = "#${colors.base05}";
    #   };
    # };
    extraConfig = /* lua */ ''
      return {
        color_scheme = "${colorscheme.slug}",

        -- window_close_confirmation = "NeverPrompt",
        -- set_environment_variables = {
        --   TERM = 'wezterm',
        -- },

        enable_tab_bar = false,
        enable_scroll_bar = false,

        -- See:
        -- https://www.reddit.com/r/archlinux/comments/18rf5t1/psa_on_hyprland_wezterm_will_not_start_anymore/?rdt=54570
        -- https://github.com/wez/wezterm/issues/4483
        enable_wayland = false,

        window_background_opacity = 0.85,
        window_padding = {
          top = 0,
          right = 0,
          bottom = 0,
          left = 0,
        },

        font_size = 11.0;
        font = wezterm.font 'JetBrains Mono Nerd Font',
        -- font = wezterm.font_with_fallback {
        --   'JetBrains Mono',
        --   'FiraCode Nerd Font',
        --   'Noto Color Emoji',
        -- },
      };
    '';
  };
}
