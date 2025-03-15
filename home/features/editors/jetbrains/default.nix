{
  config,
  lib,
  pkgs,
  flake,
  ...
}: {
  home.file = {
    ".ideavimrc".source = ./.ideavimrc;
  };

  home.packages = let
    options = {
      # See:
      # https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/
      # https://youtrack.jetbrains.com/issue/JBR-3206/Native-Wayland-support#focus=Comments-27-9421388.0-0
      enableWaylandSupport = "-Dawt.toolkit.name=WLToolkit";
      maxHeapSize = "-Xmx4096m";
    };
    vmopts = ''
      ${options.maxHeapSize}
      ${options.enableWaylandSupport}
    '';
  in [
    pkgs.android-studio

    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/jetbrains/default.nix
    (pkgs.jetbrains.webstorm.override {vmopts = vmopts;})
    (pkgs.jetbrains.rust-rover.override {vmopts = vmopts;})
    (pkgs.jetbrains.datagrip.override {vmopts = vmopts;})
    (pkgs.jetbrains.pycharm-professional.override {vmopts = vmopts;})
  ];
}
