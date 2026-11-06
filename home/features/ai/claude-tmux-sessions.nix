{
  config,
  lib,
  pkgs,
  ...
}: let
  stateDir = "${config.home.homeDirectory}/.claude/tmux-restore";
  manifest = "${stateDir}/manifest.tsv";
  spawn = "${config.home.homeDirectory}/.claude/skills/spawn/scripts/spawn.sh";

  saveSessions = pkgs.writeShellApplication {
    name = "claude-sessions-save";
    runtimeInputs = [pkgs.jq pkgs.coreutils pkgs.gawk];
    text = ''
      mkdir -p ${stateDir}
      tmp=$(mktemp)
      shopt -s nullglob
      for f in "$HOME"/.claude/sessions/*.json; do
        pid=$(basename "$f" .json)
        kill -0 "$pid" 2>/dev/null || continue
        jq -r 'select(.tmux) | [(.tmux | split(":")[0]), .cwd, .sessionId, .name // ""] | @tsv' "$f"
      done | sort -t$'\t' -k1,1 | awk -F'\t' -v OFS='\t' '{ n = $1; if (seen[n]++) n = n "-" seen[n]; $1 = n; print }' > "$tmp"

      if [ ! -s "$tmp" ]; then
        rm -f "$tmp"
        echo "no live sessions, keeping ${manifest}"
        exit 0
      fi
      mv "$tmp" ${manifest}
      echo "saved $(wc -l < ${manifest} | tr -d ' ') sessions to ${manifest}"
    '';
  };

  restoreSessions = pkgs.writeShellApplication {
    name = "claude-sessions-restore";
    runtimeInputs = [pkgs.tmux pkgs.coreutils pkgs.flock];
    text = ''
      parallel=''${PARALLEL:-3}
      boot_stamp=${stateDir}/restored-boot

      if [ "''${1:-}" = "--once-per-boot" ]; then
        mkdir -p ${stateDir}
        exec 9> ${stateDir}/restore.lock
        flock --nonblock 9 || exit 0
        boot=$(/usr/sbin/sysctl -n kern.boottime)
        [ -f "$boot_stamp" ] && [ "$(< "$boot_stamp")" = "$boot" ] && exit 0
        echo "$boot" > "$boot_stamp"
        exec > ${stateDir}/restore.log 2>&1
      fi

      [ -f ${manifest} ] || { echo "no manifest at ${manifest}" >&2; exit 1; }

      tmux start-server
      log_dir=$(mktemp -d)

      restore_one() {
        local name=$1 dir=$2 id=$3
        if tmux has-session -t "=$name" 2>/dev/null; then
          echo "skip $name: tmux session already exists"
          return
        fi
        if [ ! -d "$dir" ]; then
          echo "skip $name: $dir is gone"
          return
        fi
        ${spawn} --dir "$dir" --resume "$id" --name "$name" 2>&1 | grep -e '^session=' -e '^url=' -e 'not found' | paste -sd' ' - || true
      }

      while IFS=$'\t' read -r name dir id _title; do
        while [ "$(jobs -rp | wc -l)" -ge "$parallel" ]; do wait -n || true; done
        restore_one "$name" "$dir" "$id" > "$log_dir/$name.log" &
      done < ${manifest}
      wait

      cat "$log_dir"/*.log
      rm -rf "$log_dir"
    '';
  };
in {
  home.packages = [saveSessions restoreSessions];

  launchd.agents.claude-sessions-save = {
    enable = true;
    config = {
      ProgramArguments = ["${saveSessions}/bin/claude-sessions-save"];
      StartInterval = 300;
      StandardOutPath = "/tmp/claude-sessions-save.log";
      StandardErrorPath = "/tmp/claude-sessions-save.log";
    };
  };

  programs.fish.interactiveShellInit = lib.mkAfter ''
    if isatty stdin
      claude-sessions-restore --once-per-boot > /dev/null 2>&1 &
      disown
    end
  '';
}
