{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  programs.rio = {
    enable = false;
    settings = {
      confirm-before-quit = false;
      padding-x = 0;
      padding-y = [
        0
        0
      ];
      window = {
        decorations = "Disabled";
        startup_mode = "Maximized";
        opacity = 0.85;
      };
      fonts = {
        family = "JetBrainsMono Nerd Font";
        size = 14;
      };
      bindings = {
        keys = [
          {
            key = "space";
            "with" = "control | shift";
            action = "ToggleViMode";
          }
        ];
      };
    };
  };
}
