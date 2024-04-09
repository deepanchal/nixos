{ config, ... }: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    config = { };
    stdlib = builtins.readFile ./direnvrc;
  };

  xdg.configFile = {
    direnv-lib = {
      source = ./lib;
      target = "direnv/lib";
      recursive = true;
    };
  };
}
