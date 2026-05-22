{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia # with prime
    # inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-disable
  ];

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      libva-vdpau-driver
      nvidia-vaapi-driver
      # Intel Arrow Lake iGPU media acceleration
      intel-media-driver
      vpl-gpu-rt
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

    # IMPORTANT: The RTX 5070 Ti is a Blackwell (GB205) GPU. Blackwell is only
    # supported by the *open* kernel module — this MUST be true (the closed
    # module does not support these GPUs at all).
    open = true;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Blackwell needs a recent driver (570+). `beta` tracks the newest release in
    # nixpkgs; if the system later boots fine on the default, you can drop this.
    # If X/Wayland fails to start, this is the first thing to check.
    package = config.boot.kernelPackages.nvidiaPackages.beta;

    # PRIME offload: the Intel iGPU drives the desktop, the NVIDIA dGPU runs
    # on demand. Bus IDs come from `lspci` on this machine:
    #   00:02.0 VGA  Intel Arrow Lake iGPU   -> PCI:0:2:0
    #   02:00.0 VGA  NVIDIA RTX 5070 Ti      -> PCI:2:0:0
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true; # provides the `nvidia-offload` wrapper
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:2:0:0";
    };
  };

  environment.sessionVariables = {
    #####################################
    # NVIDIA Specific Vars
    #
    # Refs:
    # - https://github.com/Gl00ria/dotfiles/blob/main/dot_hyprland/.config/hypr/source/00_env.conf
    # - https://www.reddit.com/r/hyprland/comments/17tfwfo/comment/k8xdz7g/
    #####################################

    # Firefox
    # See: https://github.com/elFarto/nvidia-vaapi-driver?tab=readme-ov-file#firefox
    MOZ_DISABLE_RDD_SANDBOX = "1";

    # (https://wiki.archlinux.org/title/Wayland#Requirements)
    GBM_BACKEND = "nvidia-drm";

    # To force GBM as a backend
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";

    # Controls if G-Sync capable monitors should use Variable Refresh Rate (VRR)
    __GL_GSYNC_ALLOWED = "1";

    # Controls if Adaptive Sync should be used.
    __GL_VRR_ALLOWED = "1";

    # use legacy DRM interface instead of atomic mode setting. Might fix flickering
    WLR_DRM_NO_ATOMIC = "1";

    __VK_LAYER_NV_optimus = "NVIDIA_only";
    NVD_BACKEND = "direct";
    #####################################
  };

  environment.systemPackages = with pkgs; [
    vdpauinfo
    mesa-demos # provides glxinfo
    libva-utils
  ];
}
