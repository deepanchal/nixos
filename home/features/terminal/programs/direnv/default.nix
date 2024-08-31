{config, ...}: {
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # https://github.com/nix-community/nix-direnv
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    config = {};
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
