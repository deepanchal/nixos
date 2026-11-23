{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [./t3code.nix];

  launchd.agents.t3code = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.fish}/bin/fish"
        "--login"
        "--command"
        "${config.keychainAgent.attachFish}; exec ${lib.getExe' config.t3code.package "t3"} serve --host 127.0.0.1 --tailscale-serve"
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
