{ pkgs, ... }:
{
  imports = [
    ./nushell
    ./fish.nix
    ./starship.nix
    ./atuin.nix
    ./xdg.nix
  ];
}

