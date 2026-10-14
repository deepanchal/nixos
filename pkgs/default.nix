# Custom packages, that can be defined similarly to ones from nixpkgs
# You can build them using 'nix build .#example'
{pkgs ? import <nixpkgs> {}, ...}: {
  # example = pkgs.callPackage ./example { };
  codegrab = pkgs.callPackage ./codegrab {};
  dnote-cli = pkgs.callPackage ./dnote-cli {};
  fuego = pkgs.callPackage ./fuego {};
  dnote-tui = pkgs.callPackage ./dnote-tui {};
  bt-keys-sync = pkgs.callPackage ./bt-keys-sync {};
  sf-pro-fonts = pkgs.callPackage ./sf-pro-fonts {};
  oh-my-tmux = pkgs.callPackage ./oh-my-tmux {};
  mender-cli = pkgs.callPackage ./mender-cli {};
  atuin-export-fish-history = pkgs.callPackage ./atuin-export-fish-history {};
  no-mistakes = pkgs.callPackage ./no-mistakes {};
  namespace-devbox = pkgs.callPackage ./namespace-devbox {};
  slack-cli = pkgs.callPackage ./slack-cli {};
  aml-flash-tool = pkgs.callPackage ./aml-flash-tool {};
}
