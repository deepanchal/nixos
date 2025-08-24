{
  config,
  pkgs,
  ...
}:
let
  keychronUdevRule = ''
    # Udev rules for Keychron keyboards (in my case, it's for Keychron K2 HE)
    # Entry under lsusb (Bus 001 Device 013: ID 3434:0e20)
    # https://www.reddit.com/r/Keychron/comments/1e5um1u/a_linux_user_psa
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0e20", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
in
{
  services.udev.extraRules = ''
    ${keychronUdevRule}
  '';
}
