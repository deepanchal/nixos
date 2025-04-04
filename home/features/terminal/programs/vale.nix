{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    pkgs.vale # editorial style guide cli tool
  ];

  # Generated from: https://vale.sh/generator
  xdg.configFile."vale/.vale.ini".text =
    # ini
    ''
      StylesPath = styles

      MinAlertLevel = suggestion

      Packages = Google

      [*.{md}]
      # ^ This section applies to only Markdown files.
      #
      # You can change (or add) file extensions here
      # to apply these settings to other file types.
      #
      # For example, to apply these settings to both
      # Markdown and reStructuredText:
      #
      # [*.{md,rst}]
      BasedOnStyles = Vale, Google
    '';
}

