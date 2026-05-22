{
  inputs,
  ...
}: {
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      theme = "catppuccin";

      keybinds = {
        next = ["Down" "ctrl n" "ctrl j"];
        previous = ["Up" "ctrl p" "ctrl k"];
      };

      providers = {
        default = [
          "desktopapplications"
          "calc"
          "websearch"
        ];
        empty = ["desktopapplications"];

        prefixes = [
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = ">";
            provider = "runner";
          }
          {
            prefix = ":";
            provider = "clipboard";
          }
          {
            prefix = "/";
            provider = "files";
          }
          {
            prefix = ";";
            provider = "providerlist";
          }
          {
            prefix = ".";
            provider = "symbols";
          }
        ];

        # pin/unpin rebound to alt+p (ctrl+p is `previous`). Setting an action
        # list replaces the default rather than merging, so it's respecified.
        actions.desktopapplications = [
          {
            action = "start";
            default = true;
            bind = "Return";
          }
          {
            action = "start:keep";
            label = "open+next";
            bind = "shift Return";
            after = "KeepOpen";
          }
          {
            action = "new_instance";
            label = "new instance";
            bind = "ctrl Return";
          }
          {
            action = "new_instance:keep";
            label = "new+next";
            bind = "ctrl alt Return";
            after = "KeepOpen";
          }
          {
            action = "pin";
            bind = "alt p";
            after = "AsyncReload";
          }
          {
            action = "unpin";
            bind = "alt p";
            after = "AsyncReload";
          }
          {
            action = "pinup";
            bind = "alt Up";
            after = "AsyncReload";
          }
          {
            action = "pindown";
            bind = "alt Down";
            after = "AsyncReload";
          }
        ];

        # Likewise, clipboard pin/unpin rebound to alt+p.
        actions.clipboard = [
          {
            action = "copy";
            default = true;
            bind = "Return";
          }
          {
            action = "remove";
            bind = "ctrl d";
            after = "AsyncClearReload";
          }
          {
            action = "remove_all";
            label = "clear";
            bind = "ctrl shift d";
            after = "AsyncClearReload";
          }
          {
            action = "show_images_only";
            label = "only images";
            bind = "ctrl i";
            after = "AsyncClearReload";
          }
          {
            action = "show_text_only";
            label = "only text";
            bind = "ctrl i";
            after = "AsyncClearReload";
          }
          {
            action = "show_combined";
            label = "show all";
            bind = "ctrl i";
            after = "AsyncClearReload";
          }
          {
            action = "pause";
            bind = "ctrl shift p";
          }
          {
            action = "unpause";
            bind = "ctrl shift p";
          }
          {
            action = "pin";
            bind = "alt p";
            after = "AsyncClearReload";
          }
          {
            action = "unpin";
            bind = "alt p";
            after = "AsyncClearReload";
          }
          {
            action = "edit";
            bind = "ctrl o";
          }
          {
            action = "localsend";
            bind = "ctrl l";
          }
        ];
      };
    };

    # Backend provider plugins to load, matching the providers used above.
    elephant.providers = [
      "desktopapplications"
      "calc"
      "runner"
      "clipboard"
      "files"
      "websearch"
      "providerlist"
      "symbols"
    ];

    # Catppuccin Mocha vendored from github.com/krymancer/walker (mauve → blue),
    # plus local tweaks appended below.
    themes.catppuccin.style =
      builtins.readFile ./themes/catppuccin-mocha/style.css
      + ''

        /* Differentiate pinned clipboard entries. */
        .clipboard.pinned .item-text {
          color: @yellow;
        }
      '';

    # Drop the GenericName subtext so app rows show only the name.
    themes.catppuccin.layouts."item_desktopapplications" = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <requires lib="gtk" version="4.0"></requires>
        <object class="GtkBox" id="ItemBox">
          <style>
            <class name="item-box"></class>
          </style>
          <property name="orientation">horizontal</property>
          <property name="spacing">10</property>
          <child>
            <object class="GtkLabel" id="ItemImageFont">
              <style>
                <class name="item-image-text"></class>
              </style>
              <property name="width-chars">2</property>
            </object>
          </child>
          <child>
            <object class="GtkImage" id="ItemImage">
              <style>
                <class name="item-image"></class>
              </style>
              <property name="icon-size">large</property>
            </object>
          </child>
          <child>
            <object class="GtkBox" id="ItemTextBox">
              <style>
                <class name="item-text-box"></class>
              </style>
              <property name="orientation">vertical</property>
              <property name="vexpand">true</property>
              <property name="hexpand">true</property>
              <property name="vexpand-set">true</property>
              <property name="spacing">0</property>
              <child>
                <object class="GtkLabel" id="ItemText">
                  <style>
                    <class name="item-text"></class>
                  </style>
                  <property name="ellipsize">end</property>
                  <property name="vexpand_set">true</property>
                  <property name="vexpand">true</property>
                  <property name="xalign">0</property>
                </object>
              </child>
            </object>
          </child>
          <child>
            <object class="GtkLabel" id="QuickActivation">
              <style>
                <class name="item-quick-activation"></class>
              </style>
              <property name="wrap">false</property>
              <property name="valign">center</property>
              <property name="xalign">0</property>
              <property name="yalign">0.5</property>
            </object>
          </child>
        </object>
      </interface>
    '';

    # Flatten the default layout so rows hug their content (no vexpand stretching).
    themes.catppuccin.layouts."item_clipboard" = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <interface>
        <requires lib="gtk" version="4.0"></requires>
        <object class="GtkBox" id="ItemBox">
          <style>
            <class name="item-box"></class>
          </style>
          <property name="orientation">horizontal</property>
          <property name="spacing">8</property>
          <child>
            <object class="GtkBox" id="ItemTextBox">
              <style>
                <class name="item-text-box"></class>
              </style>
              <property name="orientation">vertical</property>
              <property name="hexpand">true</property>
              <property name="spacing">0</property>
              <child>
                <object class="GtkLabel" id="ItemText">
                  <style>
                    <class name="item-text"></class>
                  </style>
                  <property name="xalign">0</property>
                  <property name="ellipsize">end</property>
                  <property name="single-line-mode">true</property>
                </object>
              </child>
              <child>
                <object class="GtkLabel" id="ItemSubtext">
                  <style>
                    <class name="item-subtext"></class>
                  </style>
                  <property name="xalign">0</property>
                  <property name="single-line-mode">true</property>
                </object>
              </child>
            </object>
          </child>
          <child>
            <object class="GtkLabel" id="QuickActivation">
              <style>
                <class name="item-quick-activation"></class>
              </style>
              <property name="wrap">false</property>
              <property name="valign">center</property>
              <property name="xalign">0</property>
              <property name="yalign">0.5</property>
            </object>
          </child>
        </object>
      </interface>
    '';
  };
}
