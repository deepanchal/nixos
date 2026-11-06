{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.home-manager.users.deep.colorScheme.palette;

  rift = pkgs.rift-wm.overrideAttrs (finalAttrs: _: {
    version = "0.7.0";
    src = pkgs.fetchFromGitHub {
      owner = "acsandmann";
      repo = "rift";
      tag = "v${finalAttrs.version}";
      hash = "sha256-KpzBGim3tu1KXbN/S+ENz45wUWU72arPcCjU/wgYhGo=";
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      hash = "sha256-DxGr89iAoGhSRgW8NiZQF3jtpYF0+uurtx6sv/UCDs4=";
    };
    checkFlags = [
      "--skip=actor::reactor::tests::"
    ];
    postPatch = ''
      substituteInPlace src/actor/input.rs \
        --replace-fail "CGTapLoc::HIDEventTap," "CGTapLoc::SessionEventTap,"
    '';
  });
  riftCli = "${rift}/bin/rift-cli";

  signingIdentity = "deep-m6-mini local codesign";
  stableRiftPath = "/Users/deep/.local/libexec/rift/rift";
  prepareStableRift = pkgs.writeShellScriptBin "prepare-stable-rift" ''
    set -eu
    source=${rift}/bin/rift
    target=${stableRiftPath}
    stamp="$target.source"
    [ "$(cat "$stamp" 2>/dev/null)" = "$source" ] && exit 0
    mkdir -p "$(dirname "$target")"
    cp "$source" "$target.new"
    chmod u+w "$target.new"
    /usr/bin/codesign --force --sign "${signingIdentity}" --identifier rift "$target.new"
    mv -f "$target.new" "$target"
    echo "$source" > "$stamp"
    /bin/launchctl kickstart -k "gui/$(id -u)/org.nixos.rift"
  '';

  openApp = path: {exec = ["/usr/bin/open" "-n" path];};
  launchApp = name: {exec = ["/bin/sh" "-c" "/usr/bin/open -a '${name}'; ${riftCli} execute binding-mode default"];};
  enterMode = mode: {binding_mode = mode;};

  directions = {
    H = "left";
    J = "down";
    K = "up";
    L = "right";
  };
  directionKeys =
    lib.concatMapAttrs (key: direction: {
      "Alt + ${key}" = {move_focus = direction;};
      "Alt + Shift + ${key}" = {move_node = direction;};
    })
    directions;

  workspaceCount = 10;
  workspaceKey = index: toString (lib.mod (index + 1) 10);
  workspaceKeys = lib.mergeAttrsList (lib.genList (index: {
      "Alt + ${workspaceKey index}" = {switch_to_workspace = index;};
      "Alt + Shift + ${workspaceKey index}" = {move_window_to_workspace = index;};
    })
    workspaceCount);

  riftConfig = (pkgs.formats.toml {}).generate "rift-config.toml" {
    settings = {
      default_disable = false;
      focus_follows_mouse = true;
      mouse_follows_focus = false;
      mouse_hides_on_focus = false;
      hot_reload = true;
      drag_drop = {
        modifier = "alt";
        action1 = "move";
      };
      layout = {
        mode = "bsp";
        gaps = {
          outer = {
            top = 4;
            left = 4;
            bottom = 4;
            right = 4;
          };
          inner = {
            horizontal = 4;
            vertical = 4;
          };
        };
      };
    };

    virtual_workspaces = {
      default_workspace_count = workspaceCount;
      workspace_names = lib.genList workspaceKey workspaceCount;
    };

    keys =
      {
        "Alt + Enter" = openApp "${pkgs.alacritty}/Applications/Alacritty.app";
        "Alt + Shift + Enter" = openApp "${pkgs.ghostty-bin}/Applications/Ghostty.app";
        "Alt + Shift + Q" = "close_window";
        "Alt + F" = "toggle_fullscreen_within_gaps";
        "Alt + Shift + Space" = {toggle_window_floating = {center = true;};};
        "Alt + G" = "toggle_stack";
        "Alt + Tab" = "next_window";
        "Alt + Shift + Tab" = "prev_window";
        "Alt + Shift + R" = "reload_config";
        "Alt + R" = enterMode "resize";
        "Alt + O" = enterMode "launch";
      }
      // directionKeys
      // workspaceKeys;

    binding_modes = {
      resize = {
        H = {resize_window_shrink = "horizontal";};
        L = {resize_window_grow = "horizontal";};
        K = {resize_window_shrink = "vertical";};
        J = {resize_window_grow = "vertical";};
        Escape = enterMode "default";
        Enter = enterMode "default";
      };
      launch = {
        B = launchApp "Brave Browser";
        S = launchApp "Slack";
        Z = launchApp "Zed";
        C = launchApp "Visual Studio Code";
        Escape = enterMode "default";
      };
    };
  };
in {
  environment.systemPackages = [rift];

  home-manager.users.deep.xdg.configFile."rift/config.toml".source = riftConfig;

  launchd.user.agents.prepare-stable-rift.serviceConfig = {
    ProgramArguments = ["${prepareStableRift}/bin/prepare-stable-rift"];
    RunAtLoad = true;
    LimitLoadToSessionType = "Aqua";
    StandardOutPath = "/tmp/rift.log";
    StandardErrorPath = "/tmp/rift.log";
  };

  launchd.user.agents.rift.serviceConfig = {
    ProgramArguments = [stableRiftPath];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    LimitLoadToSessionType = "Aqua";
    StandardOutPath = "/tmp/rift.log";
    StandardErrorPath = "/tmp/rift.log";
  };

  services.jankyborders = {
    enable = true;
    width = 2.0;
    active_color = "0xff${colors.primary}";
    inactive_color = "0xff${colors.base02}";
  };
}
