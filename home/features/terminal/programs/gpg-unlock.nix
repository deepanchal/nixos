{
  config,
  lib,
  pkgs,
  ...
}: let
  signingKey = config.programs.git.signing.key;
  gpgUnlock = pkgs.writeShellApplication {
    name = "gpg-unlock";
    runtimeInputs = [config.programs.gpg.package];
    text = ''
      keygrip=$(gpg --with-colons --with-keygrip --list-secret-keys ${signingKey} | awk -F: '$1 == "grp" { print $10; exit }')
      if gpg-connect-agent "keyinfo $keygrip" /bye | grep -q "^S KEYINFO $keygrip D [^ ]* [^ ]* 1 "; then
        exit 0
      fi
      echo "Unlocking GPG signing key ${signingKey}"
      echo | gpg --pinentry-mode loopback --local-user ${signingKey} --clearsign > /dev/null
    '';
  };
in {
  home.packages = [gpgUnlock];

  programs.fish.interactiveShellInit = lib.mkAfter ''
    isatty stdin; and gpg-unlock
  '';
}
