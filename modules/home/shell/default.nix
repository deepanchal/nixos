{ pkgs, theme, ... }:
{
  imports = [
    ./nushell
    ./fish.nix
    ./starship.nix
    ./xdg.nix
  ];
}

