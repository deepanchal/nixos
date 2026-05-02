# Fish port of the oh-my-zsh `flutter` plugin.
# Source: https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/flutter/flutter.plugin.zsh
{
  programs.fish.shellAbbrs = {
    fl = "flutter";
    flattach = "flutter attach";
    flb = "flutter build";
    flchnl = "flutter channel";
    flc = "flutter clean";
    fldvcs = "flutter devices";
    fldoc = "flutter doctor";
    flpub = "flutter pub";
    flget = "flutter pub get";
    flr = "flutter run";
    flrd = "flutter run --debug";
    flrp = "flutter run --profile";
    flrr = "flutter run --release";
    flupgrd = "flutter upgrade";
  };
}
