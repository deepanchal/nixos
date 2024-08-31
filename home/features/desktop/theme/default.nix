{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./catppuccin.nix
  ];

  wallpaper = ./wallpapers/mocha-surf-wave.png; # Comes from custom wallpaper hm-module
}
