# Fish port of the oh-my-zsh `systemd` plugin.
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/systemd/systemd.plugin.zsh
{ lib, ... }:
let
  user_commands = [
    "cat"
    "get-default"
    "help"
    "is-active"
    "is-enabled"
    "is-failed"
    "is-system-running"
    "list-dependencies"
    "list-jobs"
    "list-sockets"
    "list-timers"
    "list-unit-files"
    "list-units"
    "show"
    "show-environment"
    "status"
  ];

  sudo_commands = [
    "add-requires"
    "add-wants"
    "cancel"
    "daemon-reexec"
    "daemon-reload"
    "default"
    "disable"
    "edit"
    "emergency"
    "enable"
    "halt"
    "import-environment"
    "isolate"
    "kexec"
    "kill"
    "link"
    "list-machines"
    "load"
    "mask"
    "preset"
    "preset-all"
    "reenable"
    "reload"
    "reload-or-restart"
    "reset-failed"
    "rescue"
    "restart"
    "revert"
    "set-default"
    "set-environment"
    "set-property"
    "start"
    "stop"
    "switch-root"
    "try-reload-or-restart"
    "try-restart"
    "unmask"
    "unset-environment"
  ];

  power_commands = [
    "hibernate"
    "hybrid-sleep"
    "poweroff"
    "reboot"
    "suspend"
  ];

  mkAliases = prefix: build: cmds:
    builtins.listToAttrs (
      map (c: lib.nameValuePair "${prefix}${c}" (build c)) cmds
    );
in
{
  programs.fish.shellAbbrs =
    (mkAliases "sc-"  (c: "systemctl ${c}")        user_commands)
    // (mkAliases "scu-" (c: "systemctl --user ${c}") user_commands)
    // (mkAliases "sc-"  (c: "sudo systemctl ${c}")   sudo_commands)
    // (mkAliases "scu-" (c: "systemctl --user ${c}") sudo_commands)
    // (mkAliases "sc-"  (c: "systemctl ${c}")        power_commands)
    // {
      # --now variants (sc- prefix references sudo_commands → keep sudo)
      "sc-enable-now"   = "sudo systemctl enable --now";
      "sc-disable-now"  = "sudo systemctl disable --now";
      "sc-mask-now"     = "sudo systemctl mask --now";
      "scu-enable-now"  = "systemctl --user enable --now";
      "scu-disable-now" = "systemctl --user disable --now";
      "scu-mask-now"    = "systemctl --user mask --now";

      # --failed variants
      "sc-failed"  = "systemctl --failed";
      "scu-failed" = "systemctl --user --failed";
    };
}
