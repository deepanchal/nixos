{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./xdpw # xdg-desktop-portal-wlr
    ./xdg.nix
  ];
}
