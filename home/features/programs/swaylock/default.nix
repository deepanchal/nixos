{
  config,
  pkgs,
  lib,
  ...
}: let
  c = config.colorScheme.palette;
in {
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      screenshots = true;
      font = "JetBrainsMono Nerd Font";
      show-failed-attempts = false;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-uses-ring = false;
      grace = 3;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%m-%d-%Y";
      fade-in = "0.2";
      ignore-empty-password = true;
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";

      # colors
      color = "${c.base00}";
      bs-hl-color = "${c.base06}";
      caps-lock-bs-hl-color = "${c.base06}";
      caps-lock-key-hl-color = "${c.base0B}";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "${c.base0B}";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "${c.base05}";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "${c.primary}";
      ring-clear-color = "${c.secondary}";
      ring-caps-lock-color = "${c.base09}";
      ring-ver-color = "${c.base0D}";
      ring-wrong-color = "${c.maroon}";
      separator-color = "00000000";
      text-color = "${c.base05}";
      text-clear-color = "${c.base06}";
      text-caps-lock-color = "${c.base09}";
      text-ver-color = "${c.base0D}";
      text-wrong-color = "${c.maroon}";
    };
  };
}
