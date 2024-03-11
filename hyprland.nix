{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true; # No longer needed
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  xdg.portal = {
    enable = true;
    # config.common.default = "*";
    wlr.enable = true;
    extraPortals = [
     # pkgs.xdg-desktop-portal-gtk
     pkgs.xdg-desktop-portal-hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
    # wezterm
    # cool-retro-term

    # starship
    # helix

    # qutebrowser
    # zathura
    mpv
    imv
  ];
}
