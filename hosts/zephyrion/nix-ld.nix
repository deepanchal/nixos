{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  # https://github.com/Mic92/envfs
  # A fuse filesystem that dynamically populates contents of /bin and /usr/bin/ so that it contains all executables from the PATH of the requesting process.
  # This allows executing FHS based programs on a non-FHS system.
  # For example, this is useful to execute shebangs on NixOS that assume hard coded locations like /bin or /usr/bin etc.
  services.envfs.enable = true;

  # https://github.com/nix-community/nix-ld
  # https://blog.thalheim.io/2022/12/31/nix-ld-a-clean-solution-for-issues-with-pre-compiled-executables-on-nixos/
  # https://github.com/Mic92/dotfiles/blob/8fe93df19d47c8051e569a3a72d72aa6fbf66269/nixos/modules/nix-ld.nix
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    acl
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    attr
    bzip2
    cairo
    cups
    curl
    dbus
    expat
    fontconfig
    freetype
    fuse3
    gdk-pixbuf
    glib
    gtk3
    icu
    libGL
    libappindicator-gtk3
    libdrm
    libnotify
    libpulseaudio
    libsodium
    libssh
    libunwind
    libusb1
    libuuid
    libxkbcommon
    libxml2
    libz
    mesa
    nspr
    nss
    openssl
    pango
    pipewire
    stdenv.cc.cc
    systemd
    util-linux
    vulkan-loader
    xz
    zlib
    zstd
  ];

  # Modified from: https://github.com/jlorezz/phoenix/blob/845b762828e66ff36ef8e67dffd2846424a3d6ea/modules/nixos/nix-ld.nix#L26
  # Also see: https://github.com/sebastian-eichelbaum/nixos/blob/d2eb6a3e2ebf6ff8e7ef63de1fe6b92486937418/system/workstation/desktop/nix-ld.nix
  # Set LD_LIBRARY_PATH env var for compatibility
  environment.variables = {
    LD_LIBRARY_PATH = lib.makeLibraryPath (
      with pkgs;
      [
        stdenv.cc.cc.lib # To fix: libstdc++.so.6: cannot open shared object file: No such file or directory
      ]
    );
  };
}
