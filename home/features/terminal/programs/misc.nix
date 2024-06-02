{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  programs.jq.enable = true;
  programs.taskwarrior.enable = true;
}
