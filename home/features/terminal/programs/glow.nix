{
  config,
  lib,
  pkgs,
  ...
}: let
  # NOTE: `GLAMOUR_STYLE` env var is being set by `catppuccin` nix module
  # https://github.com/catppuccin/nix/blob/630b559cc1cb4c0bdd525af506935323e4ccd5d1/modules/home-manager/glamour.nix
  glowStyle = config.home.sessionVariables.GLAMOUR_STYLE;
in {
  home.packages = [
    pkgs.glow
  ];

  programs.glamour.catppuccin.enable = true;

  xdg.configFile."glow/glow.yml".text =
    # yaml
    ''
      # style name or JSON path (default "auto")
      # We have to manually set this style till this PR gets merged
      # https://github.com/charmbracelet/glow/pull/587
      style: "${glowStyle}"
      # mouse wheel support (TUI-mode only)
      mouse: true
      # use pager to display markdown
      pager: false
      # at which column should we word wrap?
      width: 0 # disable
    '';
}
