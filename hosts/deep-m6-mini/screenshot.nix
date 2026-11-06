{pkgs, ...}: let
  screenshot = pkgs.writeShellApplication {
    name = "screenshot";
    text = ''
      dir="$HOME/Pictures/Screenshots"
      mkdir -p "$dir"
      file="$dir/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
      /usr/sbin/screencapture -i -x "$file"
      [ -f "$file" ] || exit 0
      /usr/bin/osascript -e "set the clipboard to (read (POSIX file \"$file\") as «class PNGf»)"
    '';
  };
in {
  environment.systemPackages = [screenshot];

  system.defaults.NSGlobalDomain."com.apple.keyboard.fnState" = true;
}
