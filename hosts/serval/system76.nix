# System76 hardware support for the Serval WS (replaces zephyrion's asus.nix).
#
# The generic `system76` nixos-hardware module sets
# `hardware.system76.enableAll = true`, which pulls in:
#   - the System76 firmware-update daemon (system76-firmware)
#   - system76-power (power profiles + fan/graphics control)
#   - the kernel modules: system76, system76_acpi, system76_io
{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.system76
  ];

  # NOTE: system76-power can also switch graphics modes (integrated / hybrid /
  # nvidia). Leave it in the default "hybrid" mode so the NVIDIA PRIME offload
  # configured in ./nvidia.nix works (Intel iGPU drives the desktop, the
  # RTX 5070 Ti runs on demand). Switching to "integrated" would power the
  # dGPU off entirely; "nvidia" would route everything through it.
  #   Check/change at runtime with: system76-power graphics {hybrid,integrated,nvidia}

  # TODO(serval): the Serval WS (Clevo chassis) may not support a battery
  # charge-end threshold the way zephyrion's ASUS did. If it does, it is exposed
  # via /sys/class/power_supply/BAT0/charge_control_end_threshold — wire it up
  # with a systemd oneshot if you want to cap charging at 80%.
}
