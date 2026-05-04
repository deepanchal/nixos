{pkgs, ...}: {
  imports = [
    ./nushell
    ./zsh
    ./fish
    ./starship.nix
  ];
}
