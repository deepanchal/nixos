{pkgs, ...}: {
  imports = [
    ./nushell
    ./zsh
    ./fish.nix
    ./direnv
    ./starship.nix
    ./atuin.nix
    ./xdg.nix
  ];
}
