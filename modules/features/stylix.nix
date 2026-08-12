{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.stylix = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = let
      zen-extensions = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        ublock-origin
      ];
    in [
      inputs.stylix.nixosModules.stylix
      {
        stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {inherit inputs;};
          backupFileExtension = "backup";

          # "global" home-manager -- unused so we don't care lol
          # essentially produces: home-manager.users = { alpha = {}; bravo = {}; charlie = {}; ... };
          users =
            lib.mapAttrs (_name: _user: {
              imports = [
                inputs.stylix.homeModules.stylix
                inputs.zen-browser.homeModules.twilight
              ];
              stylix = {
                enable = true;
                base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
                targets = {
                  kitty.enable = true;
                  vicinae.enable = true;
                  zen-browser.profileNames = ["default" "work"];
                };
                cursor = {
                  name = "Vimix-cursors";
                  package = pkgs.vimix-cursors;
                  size = 24;
                };
                fonts = {
                  sansSerif = {
                    name = "DejaVu Sans Mono";
                  };
                };
              };

              programs.vicinae = {
                enable = true;
                systemd.enable = false;
                package = self.packages.${pkgs.stdenv.hostPlatform.system}.myVicinae;
              };

              programs.zen-browser = {
                enable = true;
                setAsDefaultBrowser = true;

                profiles = {
                  default = {
                    id = 0;
                    isDefault = true;
                    extensions.packages = zen-extensions;
                  };
                  work = {
                    id = 1;
                    isDefault = false;
                    extensions.packages = zen-extensions;
                  };
                };
              };
              home = {
                stateVersion = "26.11";

                # home-manager's qt module sets QT_QPA_PLATFORMTHEME=qt5ct,
                # which qt6 apps (dolphin, ark, ...) can't load.
                sessionVariables.QT_QPA_PLATFORMTHEME = lib.mkForce "qt6ct";

                # https://github.com/nix-community/stylix/issues/2183#issuecomment-3952356653
                file.".config/kdeglobals".text = ''
                  [UiSettings]
                  ColorScheme=*
                '';
              };
            })
            (lib.filterAttrs (_name: user: user.homeManager.enable) config.my.users);
        };
      }
    ];

    # make the hm session env vars reach every session (vm boot/tty login,
    # display manager, `nix run` from the host shell) regardless of how niri
    # is launched, so qt apps get qt6ct/kvantum and the stylix kde theme.
    environment.sessionVariables = let
      homePath = "${config.home-manager.users.vladimir.home.activationPackage}/home-path";
    in {
      QT_QPA_PLATFORMTHEME = "qt6ct";
      QT_STYLE_OVERRIDE = "kvantum";
      # QT_PLUGIN_PATH = lib.mkForce "${homePath}/lib/qt-6/plugins:${homePath}/lib/qt-5.15.19/plugins\${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}";
      QML2_IMPORT_PATH = "${homePath}/lib/qt-6/qml:${homePath}/lib/qt-5.15.19/qml\${QML2_IMPORT_PATH:+:$QML2_IMPORT_PATH}";
      XDG_DATA_DIRS = lib.mkForce "${homePath}/share\${XDG_DATA_DIRS:+:$XDG_DATA_DIRS}";
    };
  };

  perSystem = {pkgs, ...}: {
  };
}
