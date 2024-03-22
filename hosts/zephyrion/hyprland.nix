{ pkgs, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    # enableNvidiaPatches = true; # No longer needed
  };

  environment.sessionVariables = {
    #####################################
    # NVIDIA Specific Vars
    #
    # Refs: 
    # - https://github.com/Gl00ria/dotfiles/blob/main/dot_hyprland/.config/hypr/source/00_env.conf
    # - https://www.reddit.com/r/hyprland/comments/17tfwfo/comment/k8xdz7g/
    #####################################

    # Hardware acceleration on NVIDIA GPUs
    # (https://wiki.archlinux.org/title/Hardware_video_acceleration)
    LIBVA_DRIVER_NAME = "nvidia";

    # (https://wiki.archlinux.org/title/Wayland#Requirements)
    # WARN: crashes me hyprland
    GBM_BACKEND = "nvidia-drm";

    # To force GBM as a backend
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # set to 1 to use software cursors instead of hardware cursors
    # (https://wiki.hyprland.org/hyprland-wiki/pages/Nvidia/)
    WLR_NO_HARDWARE_CURSORS = "1";

    # TIP: Advantage is all the apps will be running on nvidia
    # WARN: crashes whatever window's opened after "hibernate"
    # __NV_PRIME_RENDER_OFFLOAD = "1";

    # Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
    # See Nvidia Documentation for details.
    # (https://download.nvidia.com/XFree86/Linux-32bit-ARM/375.26/README/openglenvvariables.html)
    # __GL_GSYNC_ALLOWED = "1";

    # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid
    # having problems on some games.
    # __GL_VRR_ALLOWED = "1";

    # use legacy DRM interface instead of atomic mode setting. Might fix flickering
    # issues
    # WLR_DRM_NO_ATOMIC = "1";

    # __VK_LAYER_NV_optimus = "NVIDIA_only";
    # NVD_BACKEND = "direct";
    #####################################
  };

  xdg.portal = {
    enable = true;
    # config.common.default = "*";
    wlr.enable = true;
    extraPortals = [
      # pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
  };

  environment.systemPackages = with pkgs; [
    # wezterm
    # cool-retro-term

    # starship
    # helix

    # qutebrowser
    # zathura
    mpv
    imv
  ];
}
