{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    inputs.nixos-hardware.nixosModules.asus-zephyrus-ga503
  ];

  environment.systemPackages = with pkgs; [
    ryzenadj
    asusctl
  ];
}
