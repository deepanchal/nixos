{
  config,
  pkgs,
  ...
}: {
  launchd.agents.claude-remote-control = {
    enable = true;
    config = {
      ProgramArguments = config.driveAccess.wrap [
        "${pkgs.fish}/bin/fish"
        "--login"
        "--command"
        "${config.keychainAgent.attachFish}; while not ${pkgs.curl}/bin/curl --silent --max-time 5 --output /dev/null https://api.anthropic.com; sleep 5; end; exec claude remote-control --name ${config.home.username}@deep-m6-mini --spawn same-dir"
      ];
      WorkingDirectory = "${config.home.homeDirectory}/projects";
      RunAtLoad = true;
      KeepAlive = true;
      ThrottleInterval = 30;
      StandardOutPath = "/tmp/claude-remote-control.log";
      StandardErrorPath = "/tmp/claude-remote-control.log";
    };
  };
}
