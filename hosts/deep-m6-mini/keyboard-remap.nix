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

  cmd = ["left_command"];
  cmdShift = ["left_command" "left_shift"];
  cmdOption = ["left_command" "left_option"];

  ctrlToCmd = {
    key,
    shift ? false,
    to ? key,
    toModifiers ?
      if shift
      then cmdShift
      else cmd,
    conditions,
  }: {
    type = "basic";
    from = {
      key_code = key;
      modifiers.mandatory = ["control"] ++ lib.optional shift "shift";
    };
    to = [
      {
        key_code = to;
        modifiers = toModifiers;
      }
    ];
    inherit conditions;
  };

  braveShortcuts = [
    {key = "t";}
    {key = "n";}
    {
      key = "n";
      shift = true;
    }
    {key = "w";}
    {
      key = "w";
      shift = true;
    }
    {
      key = "t";
      shift = true;
    }
    {
      key = "q";
      shift = true;
      toModifiers = cmd;
    }
    {key = "l";}
    {key = "r";}
    {
      key = "r";
      shift = true;
    }
    {key = "f";}
    {key = "g";}
    {
      key = "g";
      shift = true;
    }
    {key = "d";}
    {
      key = "b";
      shift = true;
    }
    {
      key = "o";
      shift = true;
      to = "b";
      toModifiers = cmdOption;
    }
    {
      key = "h";
      to = "y";
    }
    {
      key = "j";
      toModifiers = cmdShift;
    }
    {
      key = "delete_or_backspace";
      shift = true;
    }
    {
      key = "a";
      shift = true;
    }
    {key = "p";}
    {key = "s";}
    {key = "o";}
    {
      key = "u";
      toModifiers = cmdOption;
    }
    {
      key = "i";
      shift = true;
      toModifiers = cmdOption;
    }
    {
      key = "j";
      shift = true;
      toModifiers = cmdOption;
    }
    {
      key = "c";
      shift = true;
    }
    {key = "equal_sign";}
    {
      key = "equal_sign";
      shift = true;
      toModifiers = cmd;
    }
    {key = "hyphen";}
    {key = "0";}
    {key = "a";}
    {key = "z";}
    {
      key = "z";
      shift = true;
    }
    {
      key = "y";
      to = "z";
      toModifiers = cmdShift;
    }
  ];

  ctrlClickToCmdClick = {
    type = "basic";
    from = {
      pointing_button = "button1";
      modifiers.mandatory = ["control"];
    };
    to = [
      {
        pointing_button = "button1";
        modifiers = cmd;
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
            description = "Linux Chrome shortcuts with Ctrl in Brave";
            manipulators = map (shortcut: ctrlToCmd (shortcut // {conditions = inBrave;})) braveShortcuts;
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
