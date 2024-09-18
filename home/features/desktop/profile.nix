{
  lib,
  pkgs,
  ...
}: let
  profilePicture = builtins.fetchurl {
    url = "https://avatars.githubusercontent.com/u/46167867?v=4";
    sha256 = "sha256:0qqzm22h31jkc1vybgihs78xwxysxjd25pvs511skrkxqn0cxznl";
  };
in {
  # profile picture
  home.file.".face".source = profilePicture;
}
