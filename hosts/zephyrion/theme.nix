{ pkgs, ... }:

{
  # Enable Theme
  environment.variables.GTK_THEME = "Catppuccin-Mocha-Standard-Teal-Dark";
  environment.variables.XCURSOR_THEME = "Catppuccin-Mocha-Teal";
  environment.variables.XCURSOR_SIZE = "24";

  # Override packages
  nixpkgs.config.packageOverrides = pkgs: {
    colloid-icon-theme = pkgs.colloid-icon-theme.override { colorVariants = [ "teal" ]; };
    catppuccin-gtk = pkgs.catppuccin-gtk.override {
      accents = [ "teal" ]; # You can specify multiple accents here to output multiple themes 
      size = "standard";
      variant = "mocha";
    };
    discord = pkgs.discord.override {
      withOpenASAR = true;
      withTTS = true;
    };
  };

  environment.systemPackages = with pkgs; [
    numix-icon-theme-circle
    colloid-icon-theme
    catppuccin-gtk
    catppuccin-kvantum
    catppuccin-cursors.mochaTeal

    # gnome.gnome-tweaks
    # gnome.gnome-shell
    # xsettingsd
    # gnome.gnome-shell-extensions
    # themechanger
  ];
}
