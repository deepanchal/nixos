{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./config.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    # NOTE: Disable config check if using swayfx
    # https://github.com/nix-community/home-manager/issues/5379#issuecomment-2096066969
    package = pkgs.swayfx;
    checkConfig = false;
  };
}
