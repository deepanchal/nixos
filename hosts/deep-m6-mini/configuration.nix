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

  nix.gc = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 4;
      Minute = 0;
    };
    options = "--delete-older-than 7d";
  };

  nix.optimise = {
    automatic = true;
    interval = {
      Weekday = 0;
      Hour = 5;
      Minute = 0;
    };
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDF9Xw0MHAmDbFHnc+Nj6ACK9RxsdRUaUyjbP8nZNXYE deep302001@gmail.com"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPCjehNU5s62WhaLuvClgO7v2nuKRueBtto+wshVpJnU #ssh.id - @deepanchal"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5D8YcLi2RpIV5qvzZg6PqcaBV7pIkMCEymrSQch1ls #ssh.id - @deepanchal"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINojSvrhuw7iD8kI8Hh/Hqb18hj13jMnWlpbuqieIqmy #SSH ID - @deepanchal"
      "from=\"127.0.0.1,::1,100.115.177.63\" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILl4KEhAGQEGM43XmRrlQimi0levtDbTlVnmF1s/T0+G loopback@deep-m6-mini"
    ];
  };

  programs.fish.enable = true;
  programs.zsh.enable = true;

  security.sudo.extraConfig = ''
    deep ALL=(ALL) NOPASSWD: ALL
  '';

  services.tailscale.enable = true;

  launchd.user.agents.sill.serviceConfig = {
    ProgramArguments = ["${pkgs.writeShellScriptBin "sill" "exec /usr/bin/open -W -g -a Sill"}/bin/sill"];
    RunAtLoad = true;
    KeepAlive = true;
    ProcessType = "Interactive";
    LimitLoadToSessionType = "Aqua";
  };

  services.openssh = {
    enable = true;
    extraConfig = ''
      PasswordAuthentication no
      KbdInteractiveAuthentication no
      AcceptEnv SSH_RESPAWN_ID SSH_RESPAWN_FROM
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
    pkgs.aml-flash-tool
    pkgs.git
  ];
}
