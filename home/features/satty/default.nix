{
  pkgs,
  config,
  inputs,
  ...
}: let
  colors = config.colorScheme.palette;
  userHome = config.home.homeDirectory;
in {
  home.packages = [
    pkgs.satty
  ];

  xdg.configFile = {
    # https://github.com/gabm/Satty?tab=readme-ov-file#configuration-file
    "satty/config.toml".text =
      # toml
      ''
        [general]
        # Start Satty in fullscreen mode
        fullscreen = false
        # Exit directly after copy/save action
        early-exit = true
        # Select the tool on startup [possible values: pointer, crop, line, arrow, rectangle, text, marker, blur, brush]
        initial-tool = "brush"
        # Configure the command to be called on copy, for example `wl-copy`
        copy-command = "wl-copy"
        # Increase or decrease the size of the annotations
        annotation-size-factor = 0.75
        # Filename to use for saving action. Omit to disable saving to file. Might contain format specifiers: https://docs.rs/chrono/latest/chrono/format/strftime/index.html
        output-filename = "${userHome}/Pictures/screenshots/ss-%Y%m%d-%H%M%S.png"
        # After copying the screenshot, save it to a file as well
        save-after-copy = false
        # Hide toolbars by default
        default-hide-toolbars = false
        # The primary highlighter to use, the other is accessible by holding CTRL at the start of a highlight [possible values: block, freehand]
        primary-highlighter = "block"
        disable-notifications = false

        # Font to use for text annotations
        [font]
        family = "JetBrainsMono Nerd Font"
        style = "Regular"

        # custom colours for the colour palette
        [color-palette]
        first= "#${colors.danger}"
        second= "#${colors.info}"
        third= "#${colors.success}"
        fourth= "#${colors.warning}"
        fifth= "#${colors.primary}"
        custom= "#${colors.accent}"
      '';
  };
}
