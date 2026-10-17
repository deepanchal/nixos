{
  config,
  lib,
  pkgs,
  ...
}: let
  colors = config.home-manager.users.deep.colorScheme.palette;
  yabai = lib.getExe config.services.yabai.package;
  jq = lib.getExe pkgs.jq;
  skhd = lib.getExe config.services.skhd.package;
  openApp = path: "open -n '${path}'";

  directions = {
    h = "west";
    j = "south";
    k = "north";
    l = "east";
  };
  directionBindings = lib.concatStrings (lib.mapAttrsToList (key: direction: ''
      alt - ${key} : ${yabai} -m window --focus ${direction}
      shift + alt - ${key} : ${yabai} -m window --swap ${direction}
    '')
    directions);

  desktopKeys = [
    {
      number = 1;
      char = 49;
      keyCode = 18;
    }
    {
      number = 2;
      char = 50;
      keyCode = 19;
    }
    {
      number = 3;
      char = 51;
      keyCode = 20;
    }
    {
      number = 4;
      char = 52;
      keyCode = 21;
    }
    {
      number = 5;
      char = 53;
      keyCode = 23;
    }
    {
      number = 6;
      char = 54;
      keyCode = 22;
    }
    {
      number = 7;
      char = 55;
      keyCode = 26;
    }
    {
      number = 8;
      char = 56;
      keyCode = 28;
    }
    {
      number = 9;
      char = 57;
      keyCode = 25;
    }
    {
      number = 10;
      char = 48;
      keyCode = 29;
    }
  ];
  switchToDesktopHotkeyId = desktop: 117 + desktop.number;
  optionModifier = 524288;
  bindSwitchToDesktop = desktop: ''
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add ${toString (switchToDesktopHotkeyId desktop)} "<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>${toString desktop.char}</integer><integer>${toString desktop.keyCode}</integer><integer>${toString optionModifier}</integer></array><key>type</key><string>standard</string></dict></dict>"
  '';
  bindDesktopShortcuts = pkgs.writeShellScript "bind-desktop-shortcuts" ''
    ${lib.concatMapStrings bindSwitchToDesktop desktopKeys}
    if [ "$(stat -f %Su /dev/console)" = "$USER" ]; then
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    fi
  '';
in {
  services.yabai = {
    enable = true;
    config = {
      layout = "bsp";
      window_placement = "second_child";
      split_ratio = 0.5;
      auto_balance = "off";
      focus_follows_mouse = "autofocus";
      mouse_follows_focus = "off";
      mouse_modifier = "alt";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      top_padding = 4;
      bottom_padding = 4;
      left_padding = 4;
      right_padding = 4;
      window_gap = 4;
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = ''
      :: default
      :: resize @
      :: launch @

      alt - return : ${openApp "${pkgs.alacritty}/Applications/Alacritty.app"}
      shift + alt - return : ${openApp "${pkgs.ghostty-bin}/Applications/Ghostty.app"}
      shift + alt - q : ${yabai} -m window --close
      alt - f : ${yabai} -m window --toggle zoom-fullscreen
      shift + alt - space : ${yabai} -m window --toggle float --grid 4:4:1:1:2:2
      alt - g : ${yabai} -m space --layout "$(${yabai} -m query --spaces --space | ${jq} -r 'if .type == "bsp" then "stack" else "bsp" end')"
      alt - tab : ${yabai} -m window --focus stack.next || ${yabai} -m window --focus stack.first
      shift + alt - tab : ${yabai} -m window --focus stack.prev || ${yabai} -m window --focus stack.last
      shift + alt - r : launchctl kickstart -k gui/$(id -u)/org.nixos.yabai
      ${directionBindings}
      alt - r ; resize
      resize < h : ${yabai} -m window --resize left:-50:0 || ${yabai} -m window --resize right:-50:0
      resize < l : ${yabai} -m window --resize right:50:0 || ${yabai} -m window --resize left:50:0
      resize < k : ${yabai} -m window --resize top:0:-50 || ${yabai} -m window --resize bottom:0:-50
      resize < j : ${yabai} -m window --resize bottom:0:50 || ${yabai} -m window --resize top:0:50
      resize < escape ; default
      resize < return ; default

      alt - o ; launch
      launch < b : open -a 'Brave Browser'; ${skhd} -k escape
      launch < s : open -a Slack; ${skhd} -k escape
      launch < z : open -a Zed; ${skhd} -k escape
      launch < c : open -a 'Visual Studio Code'; ${skhd} -k escape
      launch < escape ; default
    '';
  };

  services.jankyborders = {
    enable = true;
    width = 2.0;
    active_color = "0xff${colors.primary}";
    inactive_color = "0xff${colors.base02}";
  };

  system.activationScripts.postActivation.text = ''
    launchctl asuser 501 sudo -u deep ${bindDesktopShortcuts}
  '';
}
