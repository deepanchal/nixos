# Declarative secrets via sops-nix.
#
# Decryption identity: each machine uses its own persisted host SSH key
# (/etc/ssh/ssh_host_ed25519_key) — converted to an age key internally — so no
# extra per-host key material is needed. Recipients are managed in /.sops.yaml.
#
# Edit secrets with your personal age key:
#   SOPS_AGE_KEY_FILE=~/.secrets/.age/deep.key sops secrets/secrets.yaml
#
# Each secret is placed as a symlink at the path below, pointing into the
# tmpfs-backed /run/secrets.d, with the real decrypted file owned by deep:users
# mode 0600. The home dirs are impermanence-persisted at directory granularity,
# so the real key never lands in /persist — only the symlink does.
{
  inputs,
  config,
  pkgs,
  ...
}:
let
  user = "deep";
  homeSecret = path: {
    inherit path;
    owner = user;
    group = "users";
    mode = "0600";
  };
in
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    # Use the machine's host SSH key as the age decryption identity.
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    secrets = {
      ssh_id_ed25519 = homeSecret "/home/${user}/.ssh/id_ed25519";
      aws_credentials = homeSecret "/home/${user}/.aws/credentials";
      age_deep = homeSecret "/home/${user}/.secrets/.age/deep.key";

      # Armored GPG secret key; imported into the keyring by the
      # gpg-import-key user service (home/features/terminal/programs).
      gpg_private = homeSecret "/home/${user}/.secrets/gpg-private.asc";

      # Also deploy default age identity to the standard sops location so the
      # `sops` CLI finds it automatically (no SOPS_AGE_KEY_FILE needed)
      sops_age_keys = (homeSecret "/home/${user}/.config/sops/age/keys.txt") // {
        key = "age_deep";
      };
    };
  };
}
