{
  config,
  lib,
  pkgs,
  ...
}: let
  source = ./drive-access.c;
  launcher = "${config.home.homeDirectory}/.local/bin/drive-access";
  sourceHashFile = "${config.xdg.stateHome}/drive-access/source.sha256";
in {
  options.driveAccess.wrap = lib.mkOption {
    type = lib.types.functionTo (lib.types.listOf lib.types.str);
    readOnly = true;
    default = arguments: [launcher] ++ arguments;
  };

  config.home.activation.driveAccess = lib.hm.dag.entryAfter ["writeBoundary"] ''
    wanted=$(${pkgs.coreutils}/bin/sha256sum ${source} | ${pkgs.coreutils}/bin/cut -d' ' -f1)
    if [ ! -x ${launcher} ] || [ "$(cat ${sourceHashFile} 2>/dev/null)" != "$wanted" ]; then
      run mkdir -p "$(dirname ${launcher})" "$(dirname ${sourceHashFile})"
      run env -u SDKROOT -u DEVELOPER_DIR /usr/bin/xcrun --sdk macosx clang -O2 -o ${launcher} ${source}
      run /usr/bin/codesign --sign - --force --identifier local.drive-access ${launcher}
      run sh -c "echo $wanted > ${sourceHashFile}"
      verboseEcho "drive-access rebuilt: grant ${launcher} Full Disk Access again"
    fi
  '';
}
