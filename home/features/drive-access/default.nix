{
  config,
  lib,
  pkgs,
  ...
}: let
  home = config.home.homeDirectory;
  drive = "/Volumes/Samsung";
  treehouse = "${home}/.treehouse";
  treehouseVolumeUuid = "749F398F-4E50-4F3D-82A1-06B3BDFD6D9A";

  driveLinks = {
    ".gradle" = ".gradle";
    "Android" = "Android";
    ".pub-cache" = ".pub-cache";
    ".dartServer" = ".dartServer";
    ".cache" = ".cache";
    ".npm" = ".npm";
    ".local/share/mise" = ".local_share_mise";
  };

  ensureLinks = lib.concatStringsSep "\n" (lib.mapAttrsToList
    (name: target: "ensureDriveLink ${lib.escapeShellArg "${home}/${name}"} ${lib.escapeShellArg "${drive}/${target}"}")
    driveLinks);

  source = ./drive-access.c;
  launcher = "${home}/.local/bin/drive-access";
  sourceHashFile = "${config.xdg.stateHome}/drive-access/source.sha256";
in {
  options.driveAccess.wrap = lib.mkOption {
    type = lib.types.functionTo (lib.types.listOf lib.types.str);
    readOnly = true;
    default = arguments: [launcher] ++ arguments;
  };

  config.home.activation = {
    driveLinks = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
      ensureDriveLink() {
        local link=$1 target=$2
        if [ "$(readlink "$link")" = "$target" ]; then
          return
        fi
        if [ ! -d "$target" ]; then
          warnEcho "$target is missing, so $link was left alone. Is ${drive} mounted?"
          return
        fi
        if [ -e "$link" ] || [ -L "$link" ]; then
          warnEcho "$link is in the way of the link to $target. Move its contents to the drive and remove it."
          return
        fi
        run mkdir -p "$(dirname "$link")"
        run ln -s "$target" "$link"
      }

      ${ensureLinks}

      if ! /sbin/mount | grep -q " on ${treehouse} "; then
        warnEcho "${treehouse} is not mounted. /etc/fstab needs: UUID=${treehouseVolumeUuid} ${treehouse} apfs rw,nobrowse,owners"
      fi
    '';

    driveAccess = lib.hm.dag.entryAfter ["writeBoundary"] ''
      wanted=$(${pkgs.coreutils}/bin/sha256sum ${source} | ${pkgs.coreutils}/bin/cut -d' ' -f1)
      if [ ! -x ${launcher} ] || [ "$(cat ${sourceHashFile} 2>/dev/null)" != "$wanted" ]; then
        run mkdir -p "$(dirname ${launcher})" "$(dirname ${sourceHashFile})"
        run env -u SDKROOT -u DEVELOPER_DIR /usr/bin/xcrun --sdk macosx clang -O2 -o ${launcher} ${source}
        run /usr/bin/codesign --sign - --force --identifier local.drive-access ${launcher}
        run sh -c "echo $wanted > ${sourceHashFile}"
        verboseEcho "drive-access rebuilt: grant ${launcher} Full Disk Access again"
      fi
    '';
  };
}
