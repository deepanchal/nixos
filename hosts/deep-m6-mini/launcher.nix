{pkgs, ...}: {
  homebrew.casks = ["raycast"];

  system.defaults.CustomUserPreferences."com.raycast.macos".raycastGlobalHotkey = "Option-49";

  launchd.user.agents.raycast.serviceConfig = {
    ProgramArguments = ["${pkgs.writeShellScriptBin "raycast" "exec /usr/bin/open -W -g -a Raycast"}/bin/raycast"];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    LimitLoadToSessionType = "Aqua";
  };
}
