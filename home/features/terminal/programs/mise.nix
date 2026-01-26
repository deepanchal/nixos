{
  pkgs,
  config,
  ...
}: {
  programs.mise = {
    enable = true;
    enableBashIntegration = config.programs.bash.enable;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    globalConfig = {
      tools = {
        # node = "lts";
        # rust = "stable";
        pnpm = "latest";
        awscli = "latest";
        # python = "latest";
        # java = [
        #   "adoptopenjdk-17.0.8+7"
        # ];
        # python = [
        #   "3.11"
        # ];
      };
      alias = {};
    };
    settings = {
      verbose = false;
      experimental = true;
      all_compile = false;
      python_compile = false;
      # node_compile = false;
      disable_tools = [];
      idiomatic_version_file_enable_tools = ["python"];
    };
  };
}
