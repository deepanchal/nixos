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
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/@)" "+%Y%m%d_%H%M%S") # Using format YYYYMMDD_hhmmss (e.g. "20150825_153120")
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
      "/etc/nixos"
      "/etc/wireguard"

      "/var/log"
      "/var/cache/tuigreet" # Persist tuigreet sessions
      "/var/db/sudo/lectured" # Remember lectured sudo users
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      # "/var/lib/docker" # handled by ext4 fs mount for docker from /btr_pool/@dumps/docker-volume.img
      "/var/lib/libvirt"
      "/var/lib/alsa"
      "/var/lib/upower"
      "/var/lib/systemd"
    ];
    files = [
      "/etc/machine-id"
      "/etc/nix/tokens.conf"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];

    # the following directories will be passed to /persist/home/$USER
    users.deep = {
      directories = [
        "Downloads"
        "Music"
        "Pictures"
        "Documents"
        "Videos"
        "VirtualBox VMs"
        "projects"
        "scripts"

        "Android" # android sdk stuff
        ".android" # adb keys
        ".keychain"
        ".rustup"
        ".cargo"
        ".npm"
        ".java"
        ".gradle"
        ".pub-cache"
        ".minikube"
        ".mozilla" # firefox
        ".cache"
        ".wakatime"

        ".config/gh"
        ".config/glab-cli"
        ".config/BraveSoftware"
        ".config/Google" # android studio
        ".config/JetBrains"
        ".config/Slack"
        ".config/discord"
        ".config/google-chrome"
        ".config/spotify"

        ".local/share"
        ".local/state"

        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
        {
          directory = ".aws";
          mode = "0700";
        }
        {
          directory = ".secrets";
          mode = "0700";
        }
      ];
      files = [
        ".bash_history"
        ".wakatime.cfg"
        ".config/pavucontrol.ini"
        # ".config/gh/hosts.yml"
      ];
    };
  };

  environment.systemPackages = [
    # Script for moving dir to /persist to persist on next boot
    (pkgs.writeShellScriptBin "persist" ''
      dir="/persist/$(dirname $1)"
      sudo mkdir -p $dir
      sudo cp -rv $@ $dir
    '')
    # Script for showing the diff between the root and root-blank subvolumes.
    # This shows the ephemeral files which will be deleted on boot.
    (pkgs.writeShellScriptBin "fs-diff" ''
      set -euo pipefail

      sudo mkdir -p /mnt/fs-diff
      sudo mount -o subvol=/ /dev/disk/by-label/NIXOS /mnt/fs-diff

      OLD_TRANSID=$(sudo btrfs subvolume find-new /mnt/fs-diff/root-blank 9999999)
      OLD_TRANSID=''${OLD_TRANSID#transid marker was}

      sudo btrfs subvolume find-new "/mnt/fs-diff/@" "$OLD_TRANSID" |
      sed '$d' |
      cut -f17- -d' ' |
      sort |
      uniq |
      while read path; do
        path="/$path"
        if [ -L "$path" ]; then
          : # The path is a symbolic link, probably handled by NixOS already
        elif [ -d "$path" ]; then
          : # The path is a directory, ignore
        else
          echo "$path"
        fi
      done

      sudo umount /mnt/fs-diff
      sudo rmdir /mnt/fs-diff
    '')
  ];
}
