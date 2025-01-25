# Modified from: https://github.com/n3oney/nixus/blob/79924a0088edaf15a8606766f5c0a8172afc23a0/modules/services/uxplay.nix
{
  lib,
  config,
  pkgs,
  ...
}: {
  options.services.uxplay = {
    enable = lib.mkEnableOption "UxPlay";
  };

  config = lib.mkIf config.services.uxplay.enable {
    networking.firewall = {
      allowedTCPPorts = [7100 7000 7001];
      allowedUDPPorts = [7011 6001 6000];
    };

    services.avahi = {
      enable = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    systemd.user.services.uxplay = {
      after = ["graphical-session.target"];
      serviceConfig = {
        Restart = "on-failure";
        RestartSec = 5;
      };
      script = "${pkgs.uxplay}/bin/uxplay -n \"${config.networking.hostName}\" -nh -p";
    };
  };
}
