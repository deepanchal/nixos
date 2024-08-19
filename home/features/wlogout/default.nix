# Originally from: https://github.com/fufexan/dotfiles/blob/main/home/programs/wayland/wlogout.nix
{
  pkgs,
  config,
  lib,
  ...
}: let
  colors = config.colorscheme.palette;
  accent = config.theme.accent;
  bgImageSection = name:
  # css
  ''
    #${name} {
      background-image: url("${pkgs.wlogout}/share/wlogout/assets/${name}.svg");
    }
  '';
in {
  programs.wlogout = {
    enable = true;
    style =
      # css
      ''
        * {
          background: none;
          font-family: JetBrainsMono Nerd Font, monospace;
        }

        window {
        	background-color: alpha(#${colors.base01}, 0.8);
        }

        button {
          color: #${colors.base05};
          background-color: alpha(#${colors.base04}, 0.9);
          border-radius: 8px;
          box-shadow: inset 0 0 0 1px rgba(255, 255, 255, .1), 0 0 rgba(0, 0, 0, .5);
          margin: 1rem;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 25%;
        }

        button:focus,
        button:active,
        button:hover {
          color: #${colors.base01};
          background-color: #${accent};
        }

        ${lib.concatMapStringsSep "\n" bgImageSection [
          "lock"
          "logout"
          "suspend"
          "hibernate"
          "shutdown"
          "reboot"
        ]}
      '';
  };
}
