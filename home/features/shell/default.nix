{ pkgs, ... }:
{
  imports = [
    ./nushell
    ./fish.nix
    ./starship.nix
    ./xdg.nix
  ];
}

