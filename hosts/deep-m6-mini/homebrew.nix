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
    casks = [
      "brave-browser"
      "slack"
      "visual-studio-code"
      "zed"
    ];
  };
}
