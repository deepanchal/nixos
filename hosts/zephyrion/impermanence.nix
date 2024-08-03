{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  boot.initrd.systemd.services.rollbackup = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    requires = ["initrd-root-device.target"];
    after = ["local-fs-pre.target" "initrd-root-device.target"];
    requiredBy = ["initrd-root-fs.target"];
    unitConfig = {
      AssertPathExists = "/etc/initrd-release";
      DefaultDependencies = "no";
    };
    serviceConfig = {
      RemainAfterExit = true;
    };
    before = ["sysroot.mount"];
    serviceConfig.Type = "oneshot";
    script = ''
      echo "impermanence: Starting backup and cleanup procedure"
      mkdir /btrfs_tmp
      mount -o subvol=/ /dev/disk/by-label/NIXOS /btrfs_tmp
      if [[ -e /btrfs_tmp/@ ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/@ "/btrfs_tmp/old_roots/$timestamp"
          echo "impermanence: Old root subvolume moved to /btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
          echo "impermanence: Deleted subvolume $1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/@
      echo "impermanence: Created new root subvolume at /btrfs_tmp/@"

      umount /btrfs_tmp
      echo "impermanence: Done"
    '';
  };

  fileSystems."/persist".neededForBoot = true;

  # There are two ways to clear the root filesystem on every boot:
  ##  1. use tmpfs for /
  ##  2. (btrfs/zfs only)take a blank snapshot of the root filesystem and revert to it on every boot via:
  ##     boot.initrd.postDeviceCommands = ''
  ##       mkdir -p /run/mymount
  ##       mount -o subvol=/ /dev/disk/by-uuid/UUID /run/mymount
  ##       btrfs subvolume delete /run/mymount
  ##       btrfs subvolume snapshot / /run/mymount
  ##     '';
  #
  #  See also https://grahamc.com/blog/erase-your-darlings/

  # NOTE: impermanence only mounts the directory/file list below to /persist
  # If the directory/file already exists in the root filesystem, you should
  # move those files/directories to /persist first!
  environment.persistence."/persist" = {
    # sets the mount option x-gvfs-hide on all the bind mounts
    # to hide them from the file manager
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nixos"
      "/etc/nix/inputs"
      "/var/log"
      "/var/lib"
    ];
    files = [
      "/etc/machine-id"
    ];

    # # the following directories will be passed to /persist/home/$USER
    users.deep = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        ".gnupg"
        ".ssh"
        ".local/share"
        ".local/state"
      ];
      files = [];
    };
  };
}
