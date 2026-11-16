{config, ...}: let
  home = config.users.users.deep.home;
  volumeName = "deep-home";
in {
  system.defaults.CustomSystemPreferences."/Library/Preferences/SystemConfiguration/autodiskmount".AutomountDisksWithoutUserLogin = true;

  system.activationScripts.postActivation.text = ''
    homeDevice=$(/sbin/mount | /usr/bin/awk -v home=${home} '$3 == home {print $1}')
    homeVolume=$([ -n "$homeDevice" ] && /usr/sbin/diskutil info "$homeDevice" | /usr/bin/awk -F': *' '/Volume Name/ {print $2}')
    if [ "$homeVolume" != "${volumeName}" ]; then
      echo "warning: ${home} is not the ${volumeName} volume on the Samsung drive. /etc/fstab needs: UUID=<${volumeName} volume UUID> ${home} apfs rw,owners,nobrowse" >&2
    fi
    if [ -e /etc/kcpassword ]; then
      echo "warning: auto-login is enabled, but ${home} lives on an external volume that may not be mounted yet at login" >&2
    fi
  '';
}
