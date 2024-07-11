# Format disk with this command:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ~/nixos/hosts/zephyrion/disk-config.nix 
# Ref: https://github.com/nix-community/disko/blob/master/docs/reference.md
{lib, ...}: let
  disk = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003";
  brtfsMountOptions = ["defaults" "compress=zstd" "noatime" "discard=async" "commit=120"];
in {
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        name = "asdf";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "2M";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [
                  "defaults"
                ];
              };
            };
            MAIN = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f" "-L NIXOS"];
                postMountHook = ''
                  if [ -d /mnt/var/lib/libvirt ]; then
                  chattr +C /mnt/var/lib/libvirt
                  fi
                '';
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = brtfsMountOptions;
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = brtfsMountOptions;
                  };
                  "@home_root" = {
                    mountpoint = "/root";
                    mountOptions = brtfsMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = brtfsMountOptions;
                  };
                  "@srv" = {
                    mountpoint = "/srv";
                    mountOptions = brtfsMountOptions;
                  };
                  "@opt" = {
                    mountpoint = "/opt";
                    mountOptions = brtfsMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = brtfsMountOptions;
                  };
                  "@var_log" = {
                    mountpoint = "/var/log";
                    mountOptions = brtfsMountOptions;
                  };
                  "@var_cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = brtfsMountOptions;
                  };
                  "@var_tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = brtfsMountOptions;
                  };
                  "@var_libvirt" = {
                    mountpoint = "/var/lib/libvirt";
                    mountOptions = brtfsMountOptions;
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
