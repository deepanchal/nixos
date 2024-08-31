{pkgs, ...}: {
  imports = [
    ./nushell
    ./zsh
    ./fish.nix
    ./starship.nix
  ];
}
