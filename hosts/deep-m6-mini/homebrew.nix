{inputs, ...}: {
  imports = [
    inputs.nix-homebrew.darwinModules.nix-homebrew
  ];

  nix-homebrew = {
    enable = true;
    user = "deep";
  };

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
