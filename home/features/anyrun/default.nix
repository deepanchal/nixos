{
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    inputs.anyrun.homeManagerModules.default
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with inputs.anyrun.packages.${pkgs.system}; [
        # # An array of all the plugins you want, which either can be paths to the .so files, or their packages
        # inputs.anyrun.packages.${pkgs.system}.applications
        # ./some_plugin.so
        # "${inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins}/lib/kidex"
        applications
        dictionary
        randr
        rink
        shell
        stdin
        symbols
        translate
        websearch
      ];
      x = {fraction = 0.5;};
      y = {fraction = 0.2;};
      width = {fraction = 0.3;};

      # Hide match and plugin info icons
      hideIcons = false;

      # ignore exclusive zones, i.e. Waybar
      ignoreExclusiveZones = false;

      # Layer shell layer: Background, Bottom, Top, Overlay
      layer = "overlay";

      # Hide the plugin info panel
      hidePluginInfo = false;

      # Close window when a click outside the main box is received
      closeOnClick = true;

      # Show search results immediately when Anyrun starts
      showResultsImmediately = true;

      # Limit amount of entries shown in total
      maxEntries = null;
    };

    extraConfigFiles = {
      "applications.ron".text =
        /*
        rust
        */
        ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: true,
            max_entries: 10,
            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some("alacritty"),
          )
        '';

      "randr.ron".text =
        /*
        rust
        */
        ''
          Config(
            prefix: ":ra",
            max_entries: 5,
          )
        '';

      "shell.ron".text =
        /*
        rust
        */
        ''
          Config(
              prefix: ">",
          )
        '';

      "symbols.ron".text =
        /*
        rust
        */
        ''
          Config(
            // The prefix that the search needs to begin with to yield symbol results
            prefix: ":sy",

            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
              "Tableflip": "(╯°□°)╯︵ ┻━┻",
              "Unflip": "┬─┬ノ( º _ ºノ)",
            },

            // The number of entries to be displayed
            max_entries: 5,
          )
        '';

      "translate.ron".text =
        /*
        rust
        */
        ''
          Config(
            prefix: ":tr",
            language_delimiter: ">",
            max_entries: 5,
          )
        '';

      "websearch.ron".text =
        /*
        rust
        */
        ''
          Config(
            prefix: ":q",
            // Options: Google, Ecosia, Bing, DuckDuckGo, Custom
            //
            // Custom engines can be defined as such:
            // Custom(
            //   name: "Searx",
            //   url: "searx.be/?q={}",
            // )
            //
            // NOTE: `{}` is replaced by the search query and `https://` is automatically added in front.
            engines: [DuckDuckGo]
          )
        '';
    };

    # custom css for anyrun, based on catppuccin-mocha
    extraCss =
      /*
      css
      */
      ''
        #window,
        {
        	background: transparent;
        }
      '';
  };
}
