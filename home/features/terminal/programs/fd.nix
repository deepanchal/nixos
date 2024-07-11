{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  programs.fd = {
    enable = true;
    hidden = true;
    ignores = [
      ".git/"
      "node_modules/"
      "*.bak"
    ];
    extraOptions = [
      "--no-ignore"
      "--no-absolute-path"
    ];
  };
}
