{
  inputs,
  outputs,
  ...
}: {
  imports =
    [
      ./locale.nix
      ./fish.nix
      ./zsh.nix
      ./fail2ban.nix
    ]
    ++ (builtins.attrValues outputs.nixosModules);
}
