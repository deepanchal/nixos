{inputs, ...}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    user = "deep";
  };

  environment.systemPath = ["/opt/homebrew/bin"];

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
    taps = [
      "saffsanity/sill"
    ];
    brews = [
      "cocoapods"
      "xcodes"
    ];
    casks = [
      "android-studio"
      "brave-browser"
      "keybase"
      "localsend"
      "raspberry-pi-imager"
      "saffsanity/sill/sill"
      "slack"
      "visual-studio-code"
      "whatsapp"
      "zed"
    ];
  };
}
