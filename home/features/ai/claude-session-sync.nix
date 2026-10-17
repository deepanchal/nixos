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
    runtimeInputs = [pkgs.coreutils];
    text = ''
      projects="${claudeDir}/projects"
      synced="${syncedProjectsDir}"
      merged="${claudeDir}/synced-projects-merged"
      home_prefix=$(printf '%s' "$HOME" | tr -c '[:alnum:]' '-')

      adopt() {
        local local_dir=$1 shared_dir=$2
        if [ -e "$shared_dir" ]; then
          cp -Rp --update=none "$local_dir/." "$shared_dir/"
          mkdir -p "$merged"
          mv "$local_dir" "$merged/$(basename "$local_dir")-$(date +%s)"
        else
          mv "$local_dir" "$shared_dir"
        fi
        ln -s "$shared_dir" "$local_dir"
      }

      mkdir -p "$projects" "$synced"
      shopt -s nullglob

      for local_dir in "$projects/$home_prefix-projects" "$projects/$home_prefix-projects"-*; do
        if [ -d "$local_dir" ] && [ ! -L "$local_dir" ]; then
          adopt "$local_dir" "$synced/''${local_dir#"$projects/$home_prefix-"}"
        fi
      done

      for shared_dir in "$synced"/*; do
        local_dir="$projects/$home_prefix-$(basename "$shared_dir")"
        if [ ! -e "$local_dir" ] && [ ! -L "$local_dir" ]; then
          ln -s "$shared_dir" "$local_dir"
        fi
      done
    '';
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
