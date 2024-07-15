# Format disk with this command:
# sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ~/nixos/hosts/zephyrion/disk-config.nix
# Ref: https://github.com/nix-community/disko/blob/master/docs/reference.md
{lib, ...}: let
  user = "deep";
  disk = "/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003";
  btrfsMountOptions = ["defaults" "noatime" "compress=zstd" "autodefrag" "ssd" "discard=async" "space_cache=v2"];
  tmpfsMountOptions = ["defaults" "noatime" "size=3072M" "x-gvfs-show" "mode=1777"];
in {
  disko.devices = {
    disk = {
      disk1 = {
        type = "disk";
        device = disk;
        content = {
          type = "gpt";
          partitions = {
            MBR = {
              type = "EF02"; # for grub MBR
              size = "1M";
              priority = 1; # Needs to be first partition
            };
            ESP = {
              name = "ESP";
              size = "500M";
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
                  "" = {
                    mountpoint = "/mnt/defvol";
                    mountOptions = btrfsMountOptions;
                  };
                  "@" = {
                    mountpoint = "/";
                    mountOptions = btrfsMountOptions;
                  };
                  "@snapshots" = {
                    mountpoint = "/.snapshots";
                    mountOptions = btrfsMountOptions;
                  };
                  "@home_root" = {
                    mountpoint = "/root";
                    mountOptions = btrfsMountOptions;
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = btrfsMountOptions;
                  };
                  "@projects" = {
                    mountpoint = "/home/${user}/projects";
                    mountOptions = btrfsMountOptions;
                  };
                  "@user_cache" = {
                    mountpoint = "/home/${user}/.cache";
                    mountOptions = btrfsMountOptions;
                  };
                  "@user_config" = {
                    mountpoint = "/home/${user}/.config";
                    mountOptions = btrfsMountOptions;
                  };
                  "@srv" = {
                    mountpoint = "/srv";
                    mountOptions = btrfsMountOptions;
                  };
                  "@opt" = {
                    mountpoint = "/opt";
                    mountOptions = btrfsMountOptions;
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = btrfsMountOptions;
                  };
                  "@var_log" = {
                    mountpoint = "/var/log";
                    mountOptions = btrfsMountOptions;
                  };
                  "@var_cache" = {
                    mountpoint = "/var/cache";
                    mountOptions = btrfsMountOptions;
                  };
                  "@var_tmp" = {
                    mountpoint = "/var/tmp";
                    mountOptions = btrfsMountOptions;
                  };
                  "@var_libvirt" = {
                    mountpoint = "/var/lib/libvirt";
                    mountOptions = btrfsMountOptions;
                  };
                  "@docker" = {
                    mountpoint = "/var/lib/docker";
                    mountOptions = ["defaults"];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
  fileSystems."/tmp/ramdisk" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = tmpfsMountOptions;
  };
}
