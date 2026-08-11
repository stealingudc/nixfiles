{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.basiliskConfiguration = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.basiliskHardware
      self.nixosModules.users
      inputs.home-manager.nixosModules.home-manager
      self.nixosModules.sddm
    ];

    my.users = {
      vladimir = {
        extraGroups = ["wheel"];
        initialPassword = "password";
      };
    };

    boot = {
      loader = {
        limine.enable = true;
        efi.canTouchEfiVariables = true;
      };
      plymouth.enable = true;
      consoleLogLevel = 3;
      kernelParams = [
        "quiet"
        "udev.log_priority=3"
        "systemd.show_status=auto"
        "nvidia-drm.modeset=1"
      ];
      kernelModules = [
        "v4l2loopback"
        "nvidia"
        "nvidia-drm"
        "nvidia-uvm"
        "nvidia-modeset"
      ];
      kernelPackages = pkgs.linuxPackages_zen;
      extraModulePackages = [pkgs.linuxKernel.packages.linux_zen.v4l2loopback];

      initrd.verbose = false;
    };

    hardware.nvidia.open = true;

    time.timeZone = lib.mkDefault "Europe/Bucharest";

    i18n = {
      defaultLocale = "en_US.UTF-8";
      inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = [pkgs.fcitx5-bamboo];
          waylandFrontend = true;

          settings.inputMethod = {
            "Groups/0" = {
              "Name" = "Default";
              "Default Layout" = "us-altgr-intl";
              "DefaultIM" = "keyboard-us-altgr-intl";
            };
            "Groups/0/Items/0" = {
              "Name" = "keyboard-us-altgr-intl";
            };
            "Groups/0/Items/1" = {
              "Name" = "bamboo";
            };
          };
        };
      };
    };

    console = {
      useXkbConfig = true; # use xkb.options in tty.
    };

    networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
    networking.firewall.enable = false;

    environment.pathsToLink = ["/share/applications" "/share/xdg-desktop-portal"];

    services = {
      printing.enable = true;

      pipewire = {
        enable = true;
        pulse.enable = true;
      };

      libinput.enable = true;
      openssh.enable = true;

      xserver = {
        enable = true;
        videoDrivers = ["nvidia"];
        xkb = {
          layout = "us";
          options = "eurosign:e,caps:escape";
        };
      };
    };

    hardware.bluetooth.enable = true;

    nixpkgs = {
      config.allowUnfree = true;
      hostPlatform = "x86_64-linux";
    };

    programs = {
      nix-ld.enable = true;
      mtr.enable = true;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
      };
    };

    nix = {
      optimise.automatic = true;
      settings = {
        experimental-features = ["nix-command" "flakes"];
        auto-optimise-store = true;

        substituters = [
          "https://cache.nixos.org"
          "https://nix-community.cachix.org"
          "https://cuda-maintainers.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        ];
        trusted-users = ["root" "vladimir"];
      };
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 1w";
      };
    };

    environment.variables.EDITOR = "vim";

    system.stateVersion = "26.11";
  };
}
