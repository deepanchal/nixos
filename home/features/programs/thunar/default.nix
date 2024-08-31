{
  inputs,
  lib,
  pkgs,
  ...
}: {
  xdg.configFile."Thunar/uca.xml".source = ./uca.xml;
}
