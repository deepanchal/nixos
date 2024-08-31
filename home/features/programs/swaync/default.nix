{
  lib,
  pkgs,
  config,
  ...
}: let
  # TODO: Remove this once https://github.com/catppuccin/nix/pull/149/files gets merged
  sources = {
    swaync-mocha = builtins.fetchurl {
      url = "https://github.com/catppuccin/swaync/releases/download/v0.2.2/mocha.css";
      sha256 = "sha256-YFboTWj/hiJhmnMbGLtfcxKxvIpJxUCSVl2DgfpglfE=";
    };
  };
  defaultSwayNcFont = "Ubuntu Nerd Font";
  customSwayNcfont = "JetBrainsMono Nerd Font";
  themeRaw = sources."swaync-${config.catppuccin.flavor}";
  theme = pkgs.substitute {
    src = themeRaw;
    substitutions = [
      "--replace-warn"
      defaultSwayNcFont
      customSwayNcfont
    ];
  };
in {
  # Install the default font if it is selected
  home.packages = lib.mkIf (customSwayNcfont == defaultSwayNcFont) [
    (pkgs.nerdfonts.override {fonts = ["Ubuntu"];})
  ];

  services.swaync = {
    enable = true;
    style = theme;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
      timeout = 10;
      timeout-low = 5;
      timeout-critical = 0;
      fit-to-screen = true;
      control-center-width = 500;
      control-center-height = 600;
      notification-window-width = 500;
      keyboard-shortcuts = true;
      image-visibility = "when-available";
      transition-time = 200;
      hide-on-clear = true;
      hide-on-action = true;
      script-fail-notify = true;
      scripts = {};
      notification-visibility = {};
      widgets = [
        "inhibitors"
        "title"
        "dnd"
        "mpris"
        "notifications"
      ];
      widget-config = {
        inhibitors = {
          text = "Inhibitors";
          button-text = "Clear All";
          clear-all-button = true;
        };
        title = {
          text = "Notifications";
          clear-all-button = true;
          button-text = "Clear All";
        };
        dnd = {
          text = "Do Not Disturb";
        };
        label = {
          max-lines = 5;
          text = "Label Text";
        };
        mpris = {
          image-size = 96;
          image-radius = 12;
        };
      };
    };
  };
}
