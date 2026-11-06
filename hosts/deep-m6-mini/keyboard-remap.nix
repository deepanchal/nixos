{lib, ...}: let
  terminals = [
    "^org\\.alacritty$"
    "^com\\.mitchellh\\.ghostty$"
    "^com\\.apple\\.Terminal$"
  ];
  outsideTerminals = [
    {
      type = "frontmost_application_unless";
      bundle_identifiers = terminals;
    }
  ];

  inBrave = [
    {
      type = "frontmost_application_if";
      bundle_identifiers = ["^com\\.brave\\.Browser$"];
    }
  ];

  ctrlToCmd = {
    key,
    shift ? false,
    conditions,
  }: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.mandatory = ["control"] ++ lib.optional shift "shift";
    };
    to = [
      {
        key_code = key;
        modifiers = ["left_command"] ++ lib.optional shift "left_shift";
      }
    ];
    inherit conditions;
  };

  ctrlClickToCmdClick = {
    type = "basic";
    from = {
      pointing_button = "button1";
      modifiers.mandatory = ["control"];
    };
    to = [
      {
        pointing_button = "button1";
        modifiers = ["left_command"];
      }
    ];
  };

  hpUsbMouse = {
    identifiers = {
      is_pointing_device = true;
      vendor_id = 1121;
      product_id = 22346;
    };
    ignore = false;
  };

  karabinerConfig = {
    profiles = [
      {
        name = "Default";
        selected = true;
        virtual_hid_keyboard.keyboard_type_v2 = "ansi";
        devices = [hpUsbMouse];
        complex_modifications.rules = [
          {
            description = "Ctrl+C, Ctrl+X and Ctrl+V copy, cut and paste outside terminals";
            manipulators = map (key:
              ctrlToCmd {
                inherit key;
                conditions = outsideTerminals;
              }) ["c" "x" "v"];
          }
          {
            description = "Ctrl+T opens a tab and Ctrl+Shift+N a private window in Brave";
            manipulators = [
              (ctrlToCmd {
                key = "t";
                conditions = inBrave;
              })
              (ctrlToCmd {
                key = "n";
                shift = true;
                conditions = inBrave;
              })
            ];
          }
          {
            description = "Ctrl+click acts as Cmd+click";
            manipulators = [ctrlClickToCmdClick];
          }
        ];
      }
    ];
  };
in {
  homebrew.casks = ["karabiner-elements"];

  home-manager.users.deep.xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON karabinerConfig;
}
