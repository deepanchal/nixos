{ pkgs, config, theme, ... }:
{
  home.packages = [
    pkgs.zoxide
  ];

  programs.zoxide = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    # options = ["--cmd cd"];
  };
}

