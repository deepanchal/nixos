{pkgs, ...}: {
  imports = [
    ./nushell
    ./zsh
    ./fish.nix
  ];
}
