# Modified from: https://github.com/ryan4yin/nix-config/blob/fdcc3be59d13725cd4d93ba5f2beff3d86322f58/modules/nixos/base/btrbk.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  hostname = config.networking.hostName;
  # NOTE: btrbk's ssh:// URL form does NOT accept user@host — the user goes in
  # ssh_user below. Keep this as host-only.
  remote = "beacon.allosaurus-dojo.ts.net";
in
{
  # btrbk: daily snapshot of @persist on /btr_pool, then incremental btrfs-send
  # over SSH to pi@beacon:/mnt/btrfs-backup/zephyrion.
  # Docs: https://digint.ch/btrbk/doc/btrbk.conf.5.html
  #
  # One-time setup (zephyrion):
  #   sudo install -d -m 700 /etc/btrbk/ssh
  #   sudo ssh-keygen -t ed25519 -N "" -f /etc/btrbk/ssh/id_ed25519 -C btrbk@zephyrion
  #   sudo ssh -i /etc/btrbk/ssh/id_ed25519 pi@beacon.allosaurus-dojo.ts.net true  # pin host key
  #
  # One-time setup (beacon):
  #   sudo chown pi:pi /mnt/btrfs-backup
  #   sudo apt-get install -y btrbk
  #   # Use upstream ssh_filter_btrbk.sh
  #   sudo curl -fsSL -o /usr/local/bin/ssh_filter_btrbk.sh \
  #     https://raw.githubusercontent.com/digint/btrbk/master/ssh_filter_btrbk.sh
  #   sudo chmod +x /usr/local/bin/ssh_filter_btrbk.sh
  #   echo 'pi ALL=(root) NOPASSWD: /usr/sbin/btrfs, /usr/bin/btrbk, /usr/bin/readlink, /usr/bin/test' \
  #     | sudo tee /etc/sudoers.d/btrbk && sudo chmod 440 /etc/sudoers.d/btrbk
  #   # Append zephyrion's pubkey to /home/pi/.ssh/authorized_keys, prefixed with:
  #   #   command="/usr/local/bin/ssh_filter_btrbk.sh --sudo --target --delete -p /mnt/btrfs-backup",no-port-forwarding,no-X11-forwarding,no-agent-forwarding,no-pty
  #   # NOTE: --delete is required for retention pruning of old snapshots on
  #   # the target. Without it, sends succeed but cleanup silently fails.
  #
  # Run manually: sudo btrbk -c /etc/btrbk/btrbk-btrbk.conf {dryrun|run}

  services.btrbk.instances."btrbk" = {
    onCalendar = "daily";
    settings = {
      timestamp_format = "long";

      # Local snapshots on zephyrion / remote backups on beacon
      snapshot_preserve = "14d";
      snapshot_preserve_min = "2d";
      target_preserve = "3d 2w 3m";
      target_preserve_min = "latest";

      ssh_identity = "/etc/btrbk/ssh/id_ed25519";
      ssh_user = "pi";
      backend_remote = "btrfs-progs-sudo"; # pi is non-root, needs sudo on receive
      stream_compress = "zstd";

      volume."/btr_pool" = {
        target = "ssh://${remote}/mnt/btrfs-backup/${hostname}";
        subvolume."@persist" = {
          snapshot_create = "always";
          snapshot_dir = "@snapshots";
        };
      };
    };
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
  };

  environment.systemPackages = [
    pkgs.btrbk # For manual btrbk operations
  ];
}
