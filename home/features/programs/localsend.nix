{pkgs, ...}: let
  inbox = "%h/Downloads/LocalSend";

  clipLatestImage = pkgs.writeShellScript "localsend-clip" ''
    dir="$1"
    latest=$(ls -t "$dir" 2>/dev/null | head -1)
    [ -n "$latest" ] || exit 0

    case "''${latest,,}" in
      *.png | *.jpg | *.jpeg | *.heic | *.heif | *.webp | *.gif | *.bmp | *.tif | *.tiff) ;;
      *) exit 0 ;;
    esac

    png=$(mktemp --suffix=.png)
    if ${pkgs.imagemagick}/bin/magick "$dir/$latest" "$png"; then
      ${pkgs.wl-clipboard}/bin/wl-copy --type image/png <"$png"
      ${pkgs.libnotify}/bin/notify-send "LocalSend" "Copied $latest to clipboard"
    fi
    rm -f "$png"
  '';
in {
  systemd.user.services = {
    localsend = {
      Unit = {
        Description = "LocalSend";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target" "tray.target"];
      };
      Service = {
        ExecStart = "${pkgs.localsend}/bin/localsend_app --hidden";
        Restart = "on-failure";
        RestartSec = 5;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    localsend-clipboard = {
      Unit.Description = "Copy newest LocalSend image to the clipboard";
      Service = {
        Type = "oneshot";
        KillMode = "process";
        ExecStart = "${clipLatestImage} ${inbox}";
      };
    };
  };

  systemd.user.paths.localsend-clipboard = {
    Unit.Description = "Watch LocalSend inbox for new images";
    Path = {
      PathChanged = inbox;
      MakeDirectory = true;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
