{
  lib,
  pkgs,
  config,
  ...
}: let
  airpodsProMac = "BC:80:4E:89:10:B0";
  airpodsMaxMac = "F8:73:DF:1F:D9:92";
  headphonesMac = airpodsProMac;
in {
  home.packages = [
    (pkgs.writeShellScriptBin "bt-toggle" 
    # bash
    ''
      set -e

      HEADPHONES_MAC=${headphonesMac}
      notify-send "Bluetooth" "Toggling bluetooth"

      # First check if device exists and is paired
      if ! bluetoothctl devices | grep -q "$HEADPHONES_MAC"; then
        notify-send "Error: Device $HEADPHONES_MAC not found or not paired"
        exit 1
      fi

      # Check connection status
      if bluetoothctl devices Connected | grep -q "$HEADPHONES_MAC"; then
        # pause playing media before disconnecting
        playerctl pause
        bluetoothctl disconnect $HEADPHONES_MAC && notify-send 'Disconnected from headphones'
      else
        # Power on bluetooth if needed
        bluetoothctl power on
        # Try to connect
        bluetoothctl connect $HEADPHONES_MAC && notify-send 'Connected to headphones'
      fi
    '')
  ];
}
