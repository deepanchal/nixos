{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  colors = config.colorScheme.palette;
  anyrunPkgs = inputs.anyrun.packages.${pkgs.system};
in {
  # Originally from:
  # https://github.com/timon-schelling/nixos-genesis/blob/39be9df126ba5e54c31ead9be11d1c1aaf021bbf/src/user/desktop/anyrun/home.nix#L69-L71
  # https://github.com/coesu/nix-config/blob/da2c17fe97c7350a6da0f0bdc473c2cdd37ae38e/home/desktop/scripts.nix#L9
  home.packages = [
    (pkgs.writeShellScriptBin "anyrun-dmenu" ''
      anyrun --plugins ${pkgs.anyrun}/lib/libstdin.so --hide-plugin-info true --show-results-immediately true
    '')
    (pkgs.writeShellScriptBin "anyrun-symbols" ''
      anyrun --plugins ${pkgs.anyrun}/lib/libsymbols.so --hide-plugin-info true --show-results-immediately true
    '')
  ];

  programs.anyrun = {
    enable = true;
    config = {
      plugins = with anyrunPkgs; [
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
      hidePluginInfo = true;

      # Close window when a click outside the main box is received
      closeOnClick = true;

      # Show search results immediately when Anyrun starts
      showResultsImmediately = true;

      # Limit amount of entries shown in total
      maxEntries = null;
    };

    extraConfigFiles = {
      "stdin.ron".text =
        # rust
        ''
          Config(
            max_entries: 12,
            allow_invalid: false,
          )
        '';

      "applications.ron".text =
        # rust
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
        # rust
        ''
          Config(
            prefix: ":ra",
            max_entries: 5,
          )
        '';

      "shell.ron".text =
        # rust
        ''
          Config(
              prefix: ">",
          )
        '';

      "symbols.ron".text =
        # rust
        ''
          Config(
            // The prefix that the search needs to begin with to yield symbol results
            prefix: ":sy",

            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
              "tableflip": "(╯°□°)╯︵ ┻━┻",
              "unflip": "┬─┬ノ( º _ ºノ)",
            },

            // The number of entries to be displayed
            max_entries: 5,
          )
        '';

      "translate.ron".text =
        # rust
        ''
          Config(
            prefix: ":tr",
            language_delimiter: ">",
            max_entries: 5,
          )
        '';

      "websearch.ron".text =
        # rust
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
    extraCss = let
      primaryColor = "#${colors.primary}";
      secondaryColor = "#${colors.secondary}";
      bgColor = "#${colors.base02}";
      textColor = "#${colors.base05}";
    in
      # css
      ''
        /*
         * See:
         *  - https://docs.gtk.org/gtk4/css-properties.html#non-css-colors
         *  - https://docs.gtk.org/gtk3/css-overview.html#an-example-for-defining-colors
         *
         * To debug styling for nixos:
         *  - Copy home manager files to /tmp/anyrun with `cp -rv --dereference ~/.config/anyrun /tmp`
         *  - Edit files in /tmp/anyrun
         *  - Run anyrun with `anyrun -c /tmp/anyrun`
         */

        /* GTK Vars */
        @define-color bg-color ${bgColor};
        @define-color fg-color ${textColor};
        @define-color primary-color ${primaryColor};
        @define-color secondary-color ${secondaryColor};
        @define-color border-color @primary-color;
        @define-color selected-bg-color @primary-color;
        @define-color selected-fg-color @bg-color;

        * {
          all: unset;
          font-family: JetBrainsMono Nerd Font;
        }

        #window {
          background: transparent;
        }

        box#main {
          border-radius: 16px;
          background-color: alpha(@bg-color, 0.6);
          border: 0.5px solid alpha(@fg-color, 0.25);
        }

        entry#entry {
          font-size: 1.25rem;
          background: transparent;
          box-shadow: none;
          border: none;
          border-radius: 16px;
          padding: 16px 24px;
          min-height: 40px;
          caret-color: @primary-color;
        }

        list#main {
          background-color: transparent;
        }

        #plugin {
          background-color: transparent;
          padding-bottom: 4px;
        }

        #match {
          font-size: 1.1rem;
          padding: 2px 4px;
        }

        #match:selected,
        #match:hover {
          background-color: @selected-bg-color;
          color: @selected-fg-color;
        }

        #match:selected label#info,
        #match:hover label#info {
          color: @selected-fg-color;
        }

        #match:selected label#match-desc,
        #match:hover label#match-desc {
          color: alpha(@selected-fg-color, 0.9);
        }

        #match label#info {
          color: transparent;
          color: @fg-color;
        }

        label#match-desc {
          font-size: 1rem;
          color: @fg-color;
        }

        label#plugin {
          font-size: 16px;
        }
      '';
  };
}
