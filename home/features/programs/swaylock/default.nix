{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.swaylock = {
    enable = true;
    package = with pkgs; swaylock-effects;
    settings = {
      clock = true;
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
      fade-in = "0.1";
      ignore-empty-password = true;
    };
  };
}
