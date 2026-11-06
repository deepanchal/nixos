{pkgs, ...}: {
  homebrew.casks = ["maccy"];

  system.defaults.CustomUserPreferences."org.p0deje.Maccy" = {
    KeyboardShortcuts_popup = builtins.toJSON {
      carbonKeyCode = 8;
      carbonModifiers = 2048;
    };
  };

  launchd.user.agents.maccy.serviceConfig = {
    ProgramArguments = ["${pkgs.writeShellScriptBin "maccy" "exec /usr/bin/open -W -g -a Maccy"}/bin/maccy"];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    LimitLoadToSessionType = "Aqua";
  };
}
