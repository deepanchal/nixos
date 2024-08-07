{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  programs.jq.enable = true;
  programs.taskwarrior.enable = true;
  programs.fzf.enable = true;
  programs.gpg.enable = true;
  programs.command-not-found.enable = true; # https://discourse.nixos.org/t/which-package-is-mkfs-in/24882/3
  programs.awscli.enable = true;
  # programs.cava.enable = true;
  programs.fastfetch.enable = true;
}
