{
  config,
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
      live=$(mktemp)
      merged=$(mktemp)
      shopt -s nullglob
      for f in "$HOME"/.claude/sessions/*.json; do
        pid=$(basename "$f" .json)
        kill -0 "$pid" 2>/dev/null || continue
        jq -r 'select(.tmux) | [(.tmux | split(":")[0]), .cwd, .sessionId, .name // ""] | @tsv' "$f"
      done | sort -t$'\t' -k1,1 | awk -F'\t' -v OFS='\t' '{ n = $1; if (seen[n]++) n = n "-" seen[n]; $1 = n; print }' > "$live"

      touch ${manifest}
      {
        cat "$live"
        awk -F'\t' 'FILENAME == ARGV[1] { name[$1]; id[$3]; next } !($1 in name) && !($3 in id)' "$live" ${manifest} |
          while IFS=$'\t' read -r name dir id title; do
            if [ -d "$dir" ]; then printf '%s\t%s\t%s\t%s\n' "$name" "$dir" "$id" "$title"; fi
          done
      } | sort -t$'\t' -k1,1 > "$merged"
      mv "$merged" ${manifest}
      rm -f "$live"
      echo "saved $(wc -l < ${manifest} | tr -d ' ') sessions to ${manifest}"
    '';
  };

  restoreSessions = pkgs.writeShellApplication {
    name = "claude-sessions-restore";
    runtimeInputs = [pkgs.tmux pkgs.coreutils];
    text = ''
      parallel=''${PARALLEL:-1}
      wanted=" $* "

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
        if [ $# -gt 0 ] && [[ "$wanted" != *" $name "* ]]; then continue; fi
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
}
