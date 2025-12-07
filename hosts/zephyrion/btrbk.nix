# Modified from: https://github.com/ryan4yin/nix-config/blob/fdcc3be59d13725cd4d93ba5f2beff3d86322f58/modules/nixos/base/btrbk.nix
{
  config,
  pkgs,
  lib,
  ...
}:
let
  hostname = config.networking.hostName;
in
{
  ##############################################################################################
  # btrbk - btrfs snapshot and backup tool
  # Docs: https://digint.ch/btrbk/doc/btrbk.conf.5.html
  # Repo: https://github.com/digint/btrbk
  #
  # Usage:
  #   1. btrbk will create snapshots on schedule
  #   2. we can use `btrbk run` command to create a backup manually
  #
  # How to restore a snapshot:
  #   1. Find the snapshot you want to restore in /snapshots
  #   2. Use `btrfs subvol delete /btr_pool/@persist` to delete the current subvolume
  #   3. Use `btrfs subvol snapshot /snapshots/@persist.20251207T1130 /btr_pool/@persist` to restore the snapshot
  #   4. reboot the system or remount the filesystem to see the changes
  ##############################################################################################

  services.btrbk = {
    instances."btrbk" = {
      # onCalendar = "hourly";
      onCalendar = "daily";
      settings = {
        timestamp_format = "long";

        # how to prune local snapshots:
        # 1. keep daily snapshots for x days
        snapshot_preserve = "14d";
        # 2. keep all snapshots for x days, no matter how frequently you (or your cron job) run btrbk
        snapshot_preserve_min = "2d";

        # how to prune remote incremental backups:
        # keep daily backups for 7 days, weekly backups for 4 weeks, and monthly backups for 2 months
        target_preserve = "7d 4w 2m";
        target_preserve_min = "no";

        volume."/btr_pool" = {
          # Backup target on external drive
          target = "/btr_backup/${hostname}";
          subvolume = {
            "@persist" = {
              snapshot_create = "always";
              snapshot_dir = "@snapshots";
            };
            # "@dumps" = {
            #   snapshot_create = "always";
            #   snapshot_dir = "@snapshots";
            # };
            # "@nix" = {
            #   snapshot_create = "always";
            #   snapshot_dir = "@snapshots";
            # };
          };
        };
      };
    };
  };

  environment.systemPackages = [
    pkgs.btrbk # For manual btrbk operations
  ];
}
