{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    rustup
    gcc
    libgcc
    go
    (python311Full.withPackages(ps: with ps; [ pygobject3 gobject-introspection pyqt6-sip]))
    nodePackages_latest.nodejs
    # bun
    lua
    zig
    # numbat
  ];
}
