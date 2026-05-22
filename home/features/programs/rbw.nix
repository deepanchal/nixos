{ pkgs, ... }:
{
  # rbw is the Bitwarden CLI that walker's `bitwarden` provider drives
  # (distinct from the official `bitwarden-cli`/`bw`).
  programs.rbw = {
    enable = true;
    settings = {
      # Official bitwarden.com: leave base_url/identity_url unset. rbw appends
      # "/api" to base_url, so setting it to api.bitwarden.com 400s; the
      # defaults already point at the correct official endpoints.
      email = "deep302001@gmail.com";
      lock_timeout = 3600;
      # Graphical master-password prompt; needs `gcr` in
      # services.dbus.packages on the host (see hosts/*/services.nix).
      pinentry = pkgs.pinentry-gnome3;
    };
  };
}
