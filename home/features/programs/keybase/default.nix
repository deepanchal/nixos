{
  config,
  pkgs,
  ...
}: {
  services.keybase.enable = true;
  services.kbfs.enable = true; # keybase fs at /keybase
  home.packages = [
    pkgs.keybase-gui
  ];
}
