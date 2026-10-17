{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.home-manager.users.deep.colorScheme.palette;
  openApp = path: "exec-and-forget open -n '${path}'";
  workspaces = map toString (lib.range 1 9) ++ ["10"];
  workspaceKey = workspace:
    if workspace == "10"
    then "0"
    else workspace;
  directions = {
    h = "left";
    j = "down";
    k = "up";
    l = "right";
  };
in {
  services.jankyborders = {
    enable = true;
    width = 2.0;
    active_color = "0xff${colors.primary}";
    inactive_color = "0xff${colors.base02}";
  };

  services.aerospace = {
    enable = true;
    settings = {
      gaps = {
        inner.horizontal = 5;
        inner.vertical = 5;
        outer.left = 5;
        outer.right = 5;
        outer.top = 5;
        outer.bottom = 5;
      };

      mode.main.binding =
        {
          alt-enter = openApp "${pkgs.alacritty}/Applications/Alacritty.app";
          alt-shift-enter = openApp "${pkgs.ghostty-bin}/Applications/Ghostty.app";
          alt-shift-q = "close";
          alt-f = "fullscreen";
          alt-shift-space = "layout floating tiling";
          alt-g = "layout tiles accordion";
          alt-tab = "workspace-back-and-forth";
          alt-shift-r = "reload-config";
          alt-r = "mode resize";
          alt-o = "mode launch";
        }
        // lib.concatMapAttrs (key: direction: {
          "alt-${key}" = "focus ${direction}";
          "alt-shift-${key}" = "move ${direction}";
        })
        directions
        // lib.listToAttrs (lib.concatMap (workspace: [
            (lib.nameValuePair "alt-${workspaceKey workspace}" "workspace ${workspace}")
            (lib.nameValuePair "alt-shift-${workspaceKey workspace}" "move-node-to-workspace ${workspace}")
          ])
          workspaces);

      mode.resize.binding = {
        h = "resize width -50";
        l = "resize width +50";
        k = "resize height -50";
        j = "resize height +50";
        esc = "mode main";
        enter = "mode main";
      };

      mode.launch.binding = {
        b = ["exec-and-forget open -a 'Brave Browser'" "mode main"];
        s = ["exec-and-forget open -a Slack" "mode main"];
        z = ["exec-and-forget open -a Zed" "mode main"];
        c = ["exec-and-forget open -a 'Visual Studio Code'" "mode main"];
        esc = "mode main";
      };
    };
  };
}
