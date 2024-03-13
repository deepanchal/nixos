{ pkgs, theme, ... }:
{
  imports = [
    ./fish.nix
    ./starship.nix
    ./xdg.nix
  ];
}

