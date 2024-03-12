{ pkgs, ... }:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.deep = {
    isNormalUser = true;
    description = "Deep Panchal";
    extraGroups = [ "networkmanager" "input" "wheel" "video" "audio" ];
    shell = pkgs.fish;
    packages = with pkgs; [
      firefox
      brave
      discord
      spotify
      vscode
      slack
    ];
  };
  
  # Change runtime directory size
  # services.logind.extraConfig = "RuntimeDirectorySize=8G";
}
