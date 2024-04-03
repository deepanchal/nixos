{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia # with prime
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    # This import disables nvidia gpu. This runs only intel/amdgpu igpus and nvidia dgpus do not drain power.
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
  ];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      nvidia-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
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
    #
    # Refs:
    # - https://discourse.nixos.org/t/hardware-acceleration-on-chromium-with-nvidia/36246
    # - https://github.com/elFarto/nvidia-vaapi-driver/issues/160
    # - https://github.com/elFarto/nvidia-vaapi-driver/issues/272
    # LIBVA_DRIVER_NAME = "radeonsi";
    # LIBVA_DRIVER_NAME = "nvidia";

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
    __NV_PRIME_RENDER_OFFLOAD = "1";
    __NV_PRIME_RENDER_OFFLOAD_PROVIDER = "NVIDIA-G0";

    # Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
    # See Nvidia Documentation for details.
    # (https://download.nvidia.com/XFree86/Linux-32bit-ARM/375.26/README/openglenvvariables.html)
    __GL_GSYNC_ALLOWED = "1";

    # Controls if Adaptive Sync should be used. Recommended to set as “0” to avoid
    # having problems on some games.
    __GL_VRR_ALLOWED = "1";

    # use legacy DRM interface instead of atomic mode setting. Might fix flickering
    # issues
    WLR_DRM_NO_ATOMIC = "1";

    __VK_LAYER_NV_optimus = "NVIDIA_only";
    NVD_BACKEND = "direct";
    #####################################
  };

  environment.systemPackages = with pkgs; [
    vdpauinfo
    glxinfo
    libva-utils
    # vulkan-loader
    # vulkan-validation-layers
    # vulkan-tools
  ];
}
