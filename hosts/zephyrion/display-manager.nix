{ pkgs, ... }:

{
  services.xserver.displayManager.gdm.enable = true;

  # Enable Display Manager
  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     # default_session = {
  #     #   command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
  #     #   user = "greeter";
  #     # };
  #     default_session = {
  #       command = "${pkgs.cage}/bin/cage -s ${pkgs.greetd.gtkgreet}/bin/gtkgreet";
  #       user = "greeter";
  #     };
  #   };
  # };

  # services.greetd.enable = true;
  # programs.regreet = {
  #   enable = true;
  #   package = pkgs.greetd.regreet;
  #   settings = {
  #     cageArgs = [
  #       "-s"
  #       "-m"
  #       "last"
  #     ];
  #     commands = {
  #       reboot = [ "systemctl" "reboot" ];
  #       poweroff = [ "systemctl" "poweroff" ];
  #     };
  #   };
  # };

  environment.systemPackages = with pkgs; [
    # cage
    # greetd.tuigreet
    # greetd.gtkgreet
    # greetd.regreet
  ];
}
