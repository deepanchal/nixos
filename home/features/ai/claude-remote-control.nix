{
  config,
  pkgs,
  ...
}: {
  launchd.agents.claude-remote-control = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.fish}/bin/fish"
        "--login"
        "--command"
        "exec claude remote-control --name ${config.home.username}@deep-m6-mini --spawn same-dir"
      ];
      WorkingDirectory = "${config.home.homeDirectory}/projects";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "/dev/null";
      StandardErrorPath = "/dev/null";
    };
  };
}
