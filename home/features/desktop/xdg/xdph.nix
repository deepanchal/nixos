# From: https://github.com/diniamo/niqs/blob/6b786abc75e6536f97789a016c6dbffa4321dca4/home/hyprland/xdph.nix
{lib, ...}: let
  settings = {
    screencopy = {
      max_fps = 60;
      allow_token_by_default = true;
    };
  };
in {
  xdg.configFile."hypr/xdph.conf".text = lib.hm.generators.toHyprconf {
    attrs = settings;
  };
}
