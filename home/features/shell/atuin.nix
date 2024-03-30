{config, ...}: {
  programs.atuin = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableNushellIntegration = config.programs.nushell.enable;
    settings = {
      # Uncomment this to use your instance
      # sync_address = "https://majiy00-shell.fly.dev";
    };
  };
}
