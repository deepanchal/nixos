# Format disk with this command:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk-config.nix --arg device '"/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003"'
# Ref: https://github.com/nix-community/disko/blob/master/docs/reference.md
{
  # This is being set in flake.nix
  device ? throw "Set this to your disk device, e.g. /dev/sda or /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003",
  ...
}: {
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = device;
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              type = "EF02"; # for grub MBR
              size = "1M";
              priority = 1; # Needs to be first partition
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                  "umask=0077"
                ];
              };
            };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L NIXOS"];
                subvolumes = {
                  # mount the top-level subvolume at /btr_pool
                  # it will be used by btrbk to create snapshots
                  "/" = {
                    mountpoint = "/btr_pool";
                    # btrfs's top-level subvolume, internally has an id 5
                    # we can access all other subvolumes from this subvolume.
                    mountOptions = ["subvolid=5"];
                  };
                  "@" = {
                    mountpoint = "/";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "@persist" = {
                    mountpoint = "/persist";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                  "@snapshots" = {
                    mountpoint = "/snapshots";
                    mountOptions = ["compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
