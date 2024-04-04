{pkgs, ...}: {
  imports = [
    ./nushell
    ./zsh
    ./fish.nix
    ./starship.nix
    ./atuin.nix
    ./xdg.nix
  ];
}
