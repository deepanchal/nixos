# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  # example = pkgs.callPackage ./example { };
  dnote-cli = pkgs.callPackage ./dnote-cli {};
  dnote-tui = pkgs.callPackage ./dnote-tui {};
  bt-keys-sync = pkgs.callPackage ./bt-keys-sync {};
}
