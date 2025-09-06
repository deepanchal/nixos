{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./xdpw.nix # xdg-desktop-portal-wlr
    ./xdph.nix # xdg-desktop-portal-hyprland
    ./mimelist.nix
  ];

  xdg = {
    userDirs = {
      enable = true;
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      videos = "$HOME/Videos";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      desktop = "$HOME/Desktop";
      publicShare = "$HOME/Public";
      templates = "$HOME/Templates";
    };
  };
}
