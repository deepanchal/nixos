{
  # convert rrggbb hex to #rrggbb
  x = c: "#${c}";

  # scheme: "Catppuccin Macchiato"
  # base00: "#24273a" # base
  # base01: "#1e2030" # mantle
  # base02: "#363a4f" # surface0
  # base03: "#494d64" # surface1
  # base04: "#5b6078" # surface2
  # base05: "#cad3f5" # text
  # base06: "#f4dbd6" # rosewater
  # base07: "#b7bdf8" # lavender
  # base08: "#ed8796" # red
  # base09: "#f5a97f" # peach
  # base0A: "#eed49f" # yellow
  # base0B: "#a6da95" # green
  # base0C: "#8bd5ca" # teal
  # base0D: "#8aadf4" # blue
  # base0E: "#c6a0f6" # mauve
  # base0F: "#f0c6c6" # flamingo

  colors = rec {
    rosewater = "f2d5cf";
    flamingo = "eebebe";
    pink = "f4b8e4";
    mauve = "ca9ee6";
    red = "e78284";
    maroon = "ea999c";
    peach = "ef9f76";
    yellow = "e5c890";
    green = "a6d189";
    teal = "81c8be";
    sky = "99d1db";
    sapphire = "85c1dc";
    blue = "8caaee";
    lavender = "babbf1";
    text = "c6d0f5";
    subtext1 = "b5bfe2";
    subtext0 = "a5adce";
    overlay2 = "949cbb";
    overlay1 = "838ba7";
    overlay0 = "737994";
    surface2 = "626880";
    surface1 = "51576d";
    surface0 = "414559";
    base = "303446";
    mantle = "292c3c";
    crust = "232634";

    accent = teal;
  };

  wallpaper = ./wallpaper.png;
}
