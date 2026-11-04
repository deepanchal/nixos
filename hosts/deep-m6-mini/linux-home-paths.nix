{config, ...}: let
  user = config.system.primaryUser;
  home = config.users.users.${user}.home;
  dataHome = "/System/Volumes/Data/home";
in {
  system.activationScripts.postActivation.text = ''
    if grep -qE '^/home[[:space:]]+auto_home' /etc/auto_master; then
      sed -i "" -E 's|^(/home[[:space:]]+auto_home)|#\1|' /etc/auto_master
      automount -vc
    fi
    if mount | grep -q " on ${dataHome} "; then
      umount ${dataHome}
    fi
    mkdir -p ${dataHome}
    ln -sfn ${home} ${dataHome}/${user}
  '';
}
