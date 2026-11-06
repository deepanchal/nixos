{...}: let
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

  ctrlToCmd = key: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.mandatory = ["control"];
    };
    to = [
      {
        key_code = key;
        modifiers = ["left_command"];
      }
    ];
    conditions = outsideTerminals;
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
            manipulators = map ctrlToCmd ["c" "x" "v"];
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
