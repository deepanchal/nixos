{ pkgs, config, theme, ... }:
{
  home.packages = [
    pkgs.zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableFishIntegration = config.programs.fish.enable;
    # options = ["--cmd cd"];
  };
}

