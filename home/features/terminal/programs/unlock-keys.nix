{
  config,
  lib,
  pkgs,
  ...
}: let
  signingKey = config.programs.git.signing.key;
  keychain = config.programs.keychain;
  unlockKeys = pkgs.writeShellApplication {
    name = "unlock-keys";
    runtimeInputs = [config.programs.gpg.package keychain.package pkgs.flock];
    text = ''
      stop_tree() {
        local child
        for child in $(/usr/bin/pgrep -P "$1"); do
          stop_tree "$child"
        done
        kill -TERM "$1" 2>/dev/null || true
      }

      lock="''${TMPDIR:-/tmp}/unlock-keys.lock"
      exec 9> "$lock"
      if ! flock --nonblock 9; then
        echo "Keys are being unlocked in another terminal. Press Enter to unlock here instead."
        until flock --nonblock 9; do
          if read -r -t 1 _; then
            for pid in $(/usr/sbin/lsof -t "$lock" 2>/dev/null); do
              [ "$pid" = $$ ] || stop_tree "$pid"
            done
            flock 9
            break
          fi
        done
      fi

      keychain --quiet ${lib.escapeShellArgs keychain.keys} 9>&-

      keygrip=$(gpg --with-colons --with-keygrip --list-secret-keys ${signingKey} 9>&- | awk -F: '$1 == "grp" { print $10; exit }')
      if ! gpg-connect-agent "keyinfo $keygrip" /bye 9>&- | grep -q "^S KEYINFO $keygrip D [^ ]* [^ ]* 1 "; then
        echo "Unlocking GPG signing key ${signingKey}"
        echo | gpg --pinentry-mode loopback --local-user ${signingKey} --clearsign > /dev/null 9>&-
      fi
    '';
  };
in {
  home.packages = [unlockKeys];

  programs.fish.interactiveShellInit = lib.mkBefore ''
    if isatty stdin
      if not set -q TMUX; or test (tmux display-message -p '#{session_attached}' 2>/dev/null; or echo 0) -gt 0
        unlock-keys
      end
    end
  '';
}
