{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503
  ];


  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  services.supergfxd = {
    enable = true;
    # settings = {
    #   
    # };
  };

  environment.systemPackages = with pkgs; [
    ryzenadj
  ];
}
