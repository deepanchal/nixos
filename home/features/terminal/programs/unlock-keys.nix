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
      exec 9> "''${TMPDIR:-/tmp}/unlock-keys.lock"
      if ! flock --nonblock 9; then
        echo "Waiting for another terminal to unlock keys..."
        flock 9
      fi

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
