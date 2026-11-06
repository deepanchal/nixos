{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.home-manager.users.deep.colorScheme.palette;

  rift = pkgs.rift-wm.overrideAttrs (finalAttrs: _: {
    version = "0.7.2";
    src = pkgs.fetchFromGitHub {
      owner = "acsandmann";
      repo = "rift";
      tag = "v${finalAttrs.version}";
      hash = "sha256-LXht4AfIBiSeS5jRZiadNBFBtpvZkB9bPRF/svXLqbc=";
    };
    cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
      inherit (finalAttrs) pname version src;
      hash = "sha256-ZyRcaoNOkUKMqS77tz5ijmJR8lyAujPSpkVNbQ+6/Jo=";
    };
    patches = [./rift-dwindle.patch];
    checkFlags = [
      "--skip=actor::reactor::tests::"
      "--skip=actor::input::tests::active_mode_replacement_unbinds_default_keys_and_mode_switches_are_immediate"
      "--skip=actor::input::tests::overview_consumes_scroll_and_routes_point_deltas"
      "--skip=actor::input::tests::normal_command_after_binding_mode_transition_still_runs"
    ];
    postPatch = ''
      substituteInPlace src/actor/input.rs \
        --replace-fail "CGTapLoc::HIDEventTap," "CGTapLoc::SessionEventTap,"
    '';
  });
  riftCli = "${rift}/bin/rift-cli";

  signingIdentity = "deep-m6-mini local codesign";
  stableRiftPath = "/Users/deep/.local/libexec/rift/rift";
  prepareStableRift = pkgs.writeShellApplication {
    name = "prepare-stable-rift";
    runtimeInputs = [pkgs.jq pkgs.coreutils];
    text = ''
      restore_placement() {
        local placement=$1 active=$2 expected known
        [ -s "$placement" ] || return 0
        for _ in $(seq 60); do
          if ${riftCli} query workspaces > /dev/null 2>&1; then break; fi
          sleep 0.5
        done
        expected=$(cut -f2 "$placement" | sort)
        for _ in $(seq 40); do
          known=$(${riftCli} query windows 2>/dev/null | jq -r '.[].window_server_id' | sort)
          if [ -z "$(comm -23 <(echo "$expected") <(echo "$known"))" ]; then break; fi
          sleep 0.5
        done
        while IFS=$'\t' read -r workspace id; do
          ${riftCli} execute workspace move-window "$workspace" "$id" > /dev/null 2>&1 || true
        done < "$placement"
        if [ -n "$active" ]; then
          ${riftCli} execute workspace switch "$active" > /dev/null 2>&1 || true
        fi
      }

      source=${rift}/bin/rift
      target=${stableRiftPath}
      stamp="$target.source"
      [ "$(cat "$stamp" 2>/dev/null)" = "$source" ] && exit 0

      placement=$(mktemp)
      active=""
      if ${riftCli} query workspaces > "$placement.json" 2>/dev/null; then
        jq -r '.[] | .index as $i | .windows[] | "\($i)\t\(.window_server_id)"' "$placement.json" > "$placement"
        active=$(jq -r '.[] | select(.is_active) | .index' "$placement.json")
      fi
      rm -f "$placement.json"

      mkdir -p "$(dirname "$target")"
      cp "$source" "$target.new"
      chmod u+w "$target.new"
      /usr/bin/codesign --force --sign "${signingIdentity}" --identifier rift "$target.new"
      mv -f "$target.new" "$target"
      echo "$source" > "$stamp"
      /bin/launchctl kickstart -k "gui/$(id -u)/org.nixos.rift"

      restore_placement "$placement" "$active"
      rm -f "$placement"
    '';
  };

  alacrittyApp = "${pkgs.alacritty}/Applications/Alacritty.app";
  arrangeWorkspaces = pkgs.writeShellApplication {
    name = "arrange-workspaces";
    runtimeInputs = [pkgs.jq];
    text = ''
      state="$HOME/.local/state/arrange-workspaces"
      boot=$(/usr/sbin/sysctl -n kern.boottime)
      if [ "''${1:-}" != "--force" ] && [ "$(cat "$state" 2>/dev/null)" = "$boot" ]; then
        exit 0
      fi

      rift() { ${riftCli} "$@"; }

      window_ids() {
        rift query workspaces | jq -r --arg bundle "$1" '.[].windows[] | select(.bundle_id == $bundle) | .window_server_id' | sort
      }

      new_window_ids() {
        comm -13 <(echo "$2") <(window_ids "$1")
      }

      open_on_workspace() {
        local workspace=$1 bundle=$2 settle=$3
        shift 3
        local before
        before=$(window_ids "$bundle")
        "$@"
        for _ in $(seq 60); do
          if [ -n "$(new_window_ids "$bundle" "$before")" ]; then
            sleep "$settle"
            for id in $(new_window_ids "$bundle" "$before"); do
              rift execute workspace move-window "$workspace" "$id" > /dev/null
            done
            return
          fi
          sleep 0.5
        done
        echo "arrange-workspaces: no new $bundle window appeared" >&2
      }

      until rift query workspaces > /dev/null 2>&1; do
        sleep 1
      done

      open_on_workspace 1 com.brave.Browser 3 /usr/bin/open -a "Brave Browser"
      open_on_workspace 3 com.brave.Browser 1 /usr/bin/open -na "Brave Browser" --args --incognito
      open_on_workspace 0 org.alacritty 1 /usr/bin/open -na "${alacrittyApp}"
      open_on_workspace 0 org.alacritty 1 /usr/bin/open -na "${alacrittyApp}"
      open_on_workspace 2 org.alacritty 1 /usr/bin/open -na "${alacrittyApp}"
      open_on_workspace 2 org.alacritty 1 /usr/bin/open -na "${alacrittyApp}"
      open_on_workspace 6 com.apple.systempreferences 1 /usr/bin/open -a "System Settings"
      rift execute workspace switch 0 > /dev/null

      mkdir -p "$(dirname "$state")"
      echo "$boot" > "$state"
    '';
  };

  mod = "LCmd";
  mediaKey = pkgs.writeShellApplication {
    name = "media-key";
    text = ''
      /usr/bin/osascript -l JavaScript - "$@" <<'JXA'
      ObjC.import("Cocoa");
      ObjC.import("CoreGraphics");
      function run(argv) {
        const codes = { play: 16, next: 17, previous: 18 };
        const code = codes[argv[0]];
        if (code === undefined) throw new Error("usage: media-key play|next|previous [--dry-run]");
        for (const state of [0xa, 0xb]) {
          const flags = state << 8;
          const event = $.NSEvent.otherEventWithTypeLocationModifierFlagsTimestampWindowNumberContextSubtypeData1Data2(
            14, $.NSMakePoint(0, 0), flags, 0, 0, null, 8, (code << 16) | flags, -1);
          if (argv[1] !== "--dry-run") $.CGEventPost(0, event.CGEvent);
        }
      }
      JXA
    '';
  };
  lockScreen = pkgs.writeShellApplication {
    name = "lock-screen";
    text = ''
      /usr/bin/osascript -e 'tell application "System Events" to keystroke "q" using {control down, command down}'
    '';
  };

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
      "${mod} + ${key}" = {move_focus = direction;};
      "${mod} + Shift + ${key}" = {move_node = direction;};
    })
    directions;

  workspaceCount = 10;
  workspaceKey = index: toString (lib.mod (index + 1) 10);
  workspaceKeys = lib.mergeAttrsList (lib.genList (index: {
      "${mod} + ${workspaceKey index}" = {switch_to_workspace = index;};
      "${mod} + Shift + ${workspaceKey index}" = {move_window_to_workspace = index;};
    })
    workspaceCount);

  riftConfig = (pkgs.formats.toml {}).generate "rift-config.toml" {
    settings = {
      default_disable = false;
      focus_follows_mouse = true;
      mouse_follows_focus = false;
      mouse_hides_on_focus = false;
      hot_reload = true;
      ui.menu_bar = {
        enabled = true;
        display_style = "label";
        active_label = "index";
        mode = "all";
        show_empty = false;
      };
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
        "${mod} + Enter" = openApp "${pkgs.alacritty}/Applications/Alacritty.app";
        "${mod} + Shift + Enter" = openApp "${pkgs.ghostty-bin}/Applications/Ghostty.app";
        "${mod} + Shift + Q" = "close_window";
        "${mod} + F" = "toggle_fullscreen_within_gaps";
        "${mod} + Shift + Space" = {toggle_window_floating = {center = true;};};
        "${mod} + G" = "toggle_stack";
        "${mod} + Tab" = "next_window";
        "${mod} + Shift + Tab" = "prev_window";
        "${mod} + Shift + R" = "reload_config";
        "${mod} + R" = enterMode "resize";
        "${mod} + O" = enterMode "launch";
        "F6" = {exec = ["/run/current-system/sw/bin/screenshot"];};
        "Ctrl + Alt + L" = {exec = ["${lockScreen}/bin/lock-screen"];};
        "${mod} + Shift + M" = {exec = ["${mediaKey}/bin/media-key" "play"];};
        "${mod} + Shift + N" = {exec = ["${mediaKey}/bin/media-key" "next"];};
        "${mod} + Shift + B" = {exec = ["${mediaKey}/bin/media-key" "previous"];};
        "${mod} + Alt + H" = {resize_window_shrink = "horizontal";};
        "${mod} + Alt + L" = {resize_window_grow = "horizontal";};
        "${mod} + Alt + K" = {resize_window_shrink = "vertical";};
        "${mod} + Alt + J" = {resize_window_grow = "vertical";};
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
  environment.systemPackages = [rift arrangeWorkspaces mediaKey lockScreen];

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

  launchd.user.agents.arrange-workspaces.serviceConfig = {
    ProgramArguments = ["${arrangeWorkspaces}/bin/arrange-workspaces"];
    RunAtLoad = true;
    LimitLoadToSessionType = "Aqua";
    StandardOutPath = "/tmp/arrange-workspaces.log";
    StandardErrorPath = "/tmp/arrange-workspaces.log";
  };

  services.jankyborders = {
    enable = true;
    width = 5.0;
    active_color = "0xff${colors.primary}";
    inactive_color = "0xff${colors.base02}";
  };
}
