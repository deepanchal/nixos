{
  config,
  lib,
  pkgs,
  ...
}: let
  claudeDir = "${config.home.homeDirectory}/.claude";
  syncedProjectsDir = "${claudeDir}/synced-projects";

  linkSessions = pkgs.writeShellApplication {
    name = "claude-session-links";
    runtimeInputs = [pkgs.coreutils pkgs.findutils];
    text = builtins.readFile ./claude-session-links.sh;
  };
in {
  sync.folders = {
    claude-projects = syncedProjectsDir;
    claude-file-history = "${claudeDir}/file-history";
    claude-skills = "${claudeDir}/skills";
    claude-commands = "${claudeDir}/commands";
  };

  home.packages = [linkSessions];

  systemd.user = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
    services.claude-session-links = {
      Unit.Description = "Link Claude Code project sessions into the synced folder";
      Service = {
        Type = "oneshot";
        ExecStart = lib.getExe linkSessions;
      };
    };
    timers.claude-session-links = {
      Unit.Description = "Link new Claude Code projects into the synced folder every minute";
      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1min";
      };
      Install.WantedBy = ["timers.target"];
    };
  };

  launchd.agents.claude-session-links = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin {
    enable = true;
    config = {
      ProgramArguments = [(lib.getExe linkSessions)];
      RunAtLoad = true;
      StartInterval = 60;
    };
  };
}
