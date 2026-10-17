{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  nixpkgs = {
    hostPlatform = "aarch64-darwin";
    config.allowUnfree = true;
    overlays = [
      inputs.nur.overlays.default
      outputs.overlays.additions
    ];
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "deep"];
  };

  networking = {
    hostName = "deep-m6-mini";
    computerName = "deep-m6-mini";
    localHostName = "deep-m6-mini";
  };

  time.timeZone = "America/Chicago";

  environment.variables.LANG = "en_US.UTF-8";

  users.knownUsers = ["deep"];
  users.users.deep = {
    uid = 501;
    home = "/Users/deep";
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  security.sudo.extraConfig = ''
    deep ALL=(ALL) NOPASSWD: ALL
  '';

  services.tailscale.enable = true;

  launchd.user.agents.sunshine.serviceConfig = {
    ProgramArguments = ["${pkgs.sunshine}/bin/sunshine" "system_tray=disabled"];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    StandardOutPath = "/tmp/sunshine.log";
    StandardErrorPath = "/tmp/sunshine.log";
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
    '';
  };

  power = {
    sleep = {
      computer = "never";
      harddisk = "never";
      display = "never";
    };
    restartAfterPowerFailure = true;
  };

  system = {
    primaryUser = "deep";
    defaults.SoftwareUpdate.AutomaticallyInstallMacOSUpdates = false;
    stateVersion = 6;
  };

  environment.systemPackages = [
    pkgs.git
  ];
}
