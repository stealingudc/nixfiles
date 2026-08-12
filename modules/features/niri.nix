{
  self,
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.niri = {
    config,
    pkgs,
    ...
  }: {
    config.programs.niri = {
      enable = true;
      package = lib.mkForce self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
    imports = [
      self.nixosModules.kitty
    ];
    config.home-manager.users = self.lib.forEachHomeUser config.my.users (
      _: _: {
        home.file."Pictures/Wallpapers".source = ./wallpapers;
      }
    );
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
          [(lib.getExe self'.packages.myNoctalia) "ipc" "call" "wallpaper" "set" "~/Pictures/Wallpapers/Nix.png" "all"]
          [(lib.getExe self'.packages.myVicinae) "server"]
        ];
        input.keyboard = {
          xkb.layout = "us,ro";
        };

        prefer-no-csd = _: {};

        layout = {
          gaps = 16;
          border.width = 0;
        };

        outputs = {
          "DP-1" = {
            mode = "2560x1440@164.847";
          };
        };

        binds = {
          "Mod+A" = _: {
            props.hotkey-overlay-title = "Toggle Vicinae (App Launcher)";
            content.spawn = [(lib.getExe self'.packages.myVicinae) "toggle"];
          };
          "Mod+Return" = _: {
            content.spawn-sh = lib.getExe self'.packages.myKitty;
            props.hotkey-overlay-title = "Open Terminal (Kitty)";
          };
          "Mod+Q".close-window = _: {};
          "Mod+Slash".show-hotkey-overlay = _: {};
          "Mod+Left" = _: {
            content.focus-column-left = _: {};
            props.hotkey-overlay-title = "Focus Column to the Left (alt: Mod+H)";
          };
          "Mod+H".focus-column-left = _: {};
          "Mod+Right" = _: {
            content.focus-column-right = _: {};
            props.hotkey-overlay-title = "Focus Column to the Right (alt: Mod+L)";
          };
          "Mod+L".focus-column-right = _: {};
          "Mod+Shift+Left" = _: {
            content.move-column-left = _: {};
            props.hotkey-overlay-title = "Move Column Left (alt: Mod+Shift+H)";
          };
          "Mod+Shift+H".move-column-left = _: {};
          "Mod+Shift+Right" = _: {
            content.move-column-right = _: {};
            props.hotkey-overlay-title = "Move Column Right (alt: Mod+Shift+L)";
          };
          "Mod+Shift+L".move-column-right = _: {};
          "Mod+Up" = _: {
            content.focus-workspace-up = _: {};
            props.hotkey-overlay-title = "Switch Workspace Up (alt: Mod+K)";
          };
          "Mod+K".focus-workspace-up = _: {};
          "Mod+Down" = _: {
            content.focus-workspace-down = _: {};
            props.hotkey-overlay-title = "Switch Workspace Down (alt: Mod+J)";
          };
          "Mod+J".focus-workspace-down = _: {};
          "Mod+Shift+Up" = _: {
            content.move-column-to-workspace-up = _: {};
            props.hotkey-overlay-title = "Move Column to Workspace Up (alt: Mod+Shift+K)";
          };
          "Mod+Shift+K".move-column-to-workspace-up = _: {};
          "Mod+Shift+Down" = _: {
            content.move-column-to-workspace-down = _: {};
            props.hotkey-overlay-title = "Move Column to Workspace Down (alt: Mod+Shift+J)";
          };
          "Mod+Shift+J".move-column-to-workspace-down = _: {};
          "Mod+F".maximize-column = _: {};
          "Mod+W".toggle-window-floating = _: {};
          "Mod+E".switch-focus-between-floating-and-tiling = _: {};
          "Mod+Tab".focus-monitor-next = _: {};
        };

        window-rules = [
          {
            matches = [{app-id = ".*";}];
            geometry-corner-radius = 8;
            clip-to-geometry = true;
            focus-ring.width = 2;
          }
          {
            matches = [
              {app-id = "org.kde.dolphin";}
              {app-id = "org.kde.ark";}
              {app-id = "io.github.h2c2h2knight.hardinfo2";}
              {app-id = "org.keepassxc.KeePassXC";}
              {app-id = "kitty";}
              {app-id = "org.kde.gwenview";}
              {app-id = "com.kdiff3.KDiff3";}
            ];
            background-effect.blur = true;
            opacity = 0.8;
          }
        ];
      };
    };
  };
}
