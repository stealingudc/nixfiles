{
  self,
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.users = {
    config,
    lib,
    ...
  }: let
    cfg = config.my.users;
  in {
    options.my.users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          isNormalUser = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };

          extraGroups = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [];
          };

          initialPassword = lib.mkOption {
            type = lib.types.str;
            default = "";
          };

          homeManager.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
          };
        };
      });

      default = {};
    };

    config.users.users =
      lib.mapAttrs (_name: user: {
        inherit (user) isNormalUser extraGroups initialPassword;
      })
      cfg;
  };

}
