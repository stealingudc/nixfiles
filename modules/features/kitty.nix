{
  self,
  inputs,
  ...
}: let
  systemConfig = self.nixosConfigurations.basilisk-full.config;
  kittyTheme = systemConfig.lib.stylix.colors {
    templateRepo = systemConfig.stylix.inputs.tinted-kitty;
    target = "base16";
  };
in {
  flake.nixosModules.kitty = {
    config,
    pkgs,
    ...
  }: {
    config.home-manager.users = self.lib.forEachHomeUser config.my.users (
      _: _: {
        programs.kitty = {
          enable = true;
          package = self.packages.${pkgs.stdenv.hostPlatform.system}.myKitty;
        };
      }
    );
  };
  perSystem = {pkgs, ...}: {
    packages.myKitty = inputs.wrapper-modules.wrappers.kitty.wrap {
      inherit pkgs;
      settings = {
        background_opacity = 0.95;
        background_blur = 1;
      };
      extraConfig = ''
        include ${kittyTheme}
      '';
    };
  };
}
