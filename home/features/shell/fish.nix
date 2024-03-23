{ pkgs, lib, ... }:
{
  programs.fish = {
    enable = true;
    # interactiveShellInit = ''
    #   eval "$(${lib.getExe pkgs.starship} init fish)"
    # '';

    shellAliases = {
      cat = "bat";
    };

    shellInit = ''
      # Ctrl + Space to accept auto suggestion
      bind -k nul accept-autosuggestion
    '';

    shellAbbrs = {
      # Git
      gco = "git checkout";
      gsb = "git status -b";
      gp = "git push";
      gl = "git pull";
    };

  };
}
