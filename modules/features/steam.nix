{inputs, ...}: {
  flake.nixosModules.steam = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      package = inputs.millennium.packages.${pkgs.stdenv.hostPlatform.system}.millennium-steam;
    };
  };
}
