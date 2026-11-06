{
  config,
  lib,
  pkgs,
  ...
}: let
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;
  popupShortcut = builtins.toJSON {
    carbonKeyCode = 8;
    carbonModifiers = 2048;
  };
in {
  homebrew.casks = ["maccy"];

  system.activationScripts.postActivation.text = ''
    if [ ! -d ${home}/Library/Containers/org.p0deje.Maccy ]; then
      sudo -u ${user} defaults write org.p0deje.Maccy KeyboardShortcuts_popup -string ${lib.escapeShellArg popupShortcut}
    fi
  '';

  launchd.user.agents.maccy.serviceConfig = {
    ProgramArguments = ["${pkgs.writeShellScriptBin "maccy" "exec /usr/bin/open -W -g -a Maccy"}/bin/maccy"];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    LimitLoadToSessionType = "Aqua";
  };
}
