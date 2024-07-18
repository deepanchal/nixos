{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.catppuccin.nixosModules.catppuccin
  ];

  catppuccin = {
    # enable for all programs
    enable = true;
    # Type: one of “latte”, “frappe”, “macchiato”, “mocha”
    flavor = "mocha";
    # Type: one of “blue”, “flamingo”, “green”, “lavender”, “maroon”, “mauve”, “peach”, “pink”, “red”, “rosewater”, “sapphire”, “sky”, “teal”, “yellow”
    accent = "blue";
  };
}
