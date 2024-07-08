{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: let
in {
  programs.git = {
    enable = true;
    delta = {
      enable = true;
    };

    lfs = {
      enable = true;
    };

    userName = "Deep Panchal";
    userEmail = "deep302001@gmail.com";
  };
}
