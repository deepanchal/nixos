{
  inputs,
  config,
  ...
}: {
  imports = [inputs.tether.nixosModules.default];

  programs.tether = {
    enable = true;
    wifi = {
      enable = true;
      openFirewall = true;
    };
    bluetooth.enable = true;
  };

  systemd.packages = [config.programs.tether.package];
  systemd.user.services.tetherd.wantedBy = ["default.target"];

  environment.persistence."/persist".users.deep.directories = [".config/tether"];
}
