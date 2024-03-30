{
  inputs,
  outputs,
  ...
}: {
  imports = [
    ./locale.nix
    ./fish.nix
    ./fail2ban.nix
  ];
}
