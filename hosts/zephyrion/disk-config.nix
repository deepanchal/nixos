{
  # Format disk with this command:
  # sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disk-config.nix --arg device '"/dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003"'
  device ? throw "Set this to your disk device, e.g. /dev/sda or /dev/disk/by-id/ata-SanDisk_SSD_PLUS_240GB_191386466003",
  ...
}: {
  # Dedicated file system for Docker to prevent btrfs corruption
  # https://gist.github.com/hopeseekr/cd2058e71d01deca5bae9f4e5a555440
  # See postMountHook in disk-config.nix which creates a ext4 img for docker
  fileSystems."/var/lib/docker" = {
    device = "/btr_pool/@dumps/docker-volume.img";
    fsType = "ext4";
    options = ["loop"];
  };

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
                postCreateHook = ''
                  MNTPOINT=$(mktemp -d)
                  mount "/dev/disk/by-label/NIXOS" "$MNTPOINT" -o subvol=/
                  trap 'umount $MNTPOINT; rm -rf $MNTPOINT' EXIT

                  # Take blank root snapshot for impermanence / fs-diff
                  echo "[postCreateHook] Taking blank root (@) snapshot..."
                  btrfs subvolume snapshot -r $MNTPOINT/@ $MNTPOINT/root-blank

                  # Dedicated ext4 file system for docker to prevent btrfs corruption
                  # https://gist.github.com/hopeseekr/cd2058e71d01deca5bae9f4e5a555440
                  echo "[postCreateHook] Creating ext4 fs inside btrfs for docker..."
                  pushd $MNTPOINT/@dumps
                  touch docker-volume.img
                  chattr +C docker-volume.img
                  fallocate -l 30G docker-volume.img
                  mkfs.ext4 docker-volume.img # Note: make sure you have e2fsprogs nix pkg installed to use mkfs.ext4 command
                  popd # disko will show target busy if dir is in use
                '';
                postMountHook = ''
                  if [ -d /mnt/var/lib/libvirt ]; then
                    chattr +C /mnt/var/lib/libvirt
                  fi
                '';
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
                  # Subvol to store all data dumps with CopyOnWrite (CoW) disabled
                  "@dumps" = {};
                };
              };
            };
          };
        };
      };
    };
  };
}
