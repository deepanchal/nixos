{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
in {
  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      prompt = "enable";
      aliases = {
        prc = "pr create";
      };
    };
  };
}
