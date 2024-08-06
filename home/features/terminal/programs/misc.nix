{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  programs.jq.enable = true;
  programs.taskwarrior.enable = true;
  programs.command-not-found.enable = true; # https://discourse.nixos.org/t/which-package-is-mkfs-in/24882/3
  programs.awscli = {
    enable = true;
    credentials = {
      # "default" = {
      #   "credential_process" = "${pkgs.pass}/bin/pass show aws";
      # };
    };
    settings = {
      "default" = {
        # region = "eu-west-3";
        output = "json";
      };
    };
  };
}
