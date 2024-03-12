{ pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    BROWSER = "firefox";

    # For nvidia
    GBM_BACKEND = "nvidia-drm";
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Wayland
    NIXOS_OZONE_WL = "1";
    GDK_BACKEND = "wayland,x11";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };
}
