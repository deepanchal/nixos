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
      holder="$lock.holder"
      exec 9> "$lock"
      if ! flock --nonblock 9; then
        echo "Keys are being unlocked in another terminal. Press Enter to unlock here instead."
        until flock --nonblock 9; do
          if read -r -t 1 _; then
            if [ -s "$holder" ]; then
              stop_tree "$(cat "$holder")"
            fi
            flock 9
            break
          fi
        done
      fi
      echo $$ > "$holder"

      keychain --quiet ${lib.escapeShellArgs keychain.keys}

      keygrip=$(gpg --with-colons --with-keygrip --list-secret-keys ${signingKey} | awk -F: '$1 == "grp" { print $10; exit }')
      if ! gpg-connect-agent "keyinfo $keygrip" /bye | grep -q "^S KEYINFO $keygrip D [^ ]* [^ ]* 1 "; then
        echo "Unlocking GPG signing key ${signingKey}"
        echo | gpg --pinentry-mode loopback --local-user ${signingKey} --clearsign > /dev/null
      fi
    '';
  };
in {
  home.packages = [unlockKeys];

  programs.fish.interactiveShellInit = lib.mkBefore ''
    isatty stdin; and unlock-keys
  '';
}
