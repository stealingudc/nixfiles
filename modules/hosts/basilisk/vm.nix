{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.basiliskVMConfiguration = {...}: {
    imports = [
      self.nixosModules.users
      self.nixosModules.sddm
      inputs.home-manager.nixosModules.home-manager
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

    my.users = {
      vladimir = {
        extraGroups = ["wheel"];
        initialPassword = "password";
      };
    };

    virtualisation.vmVariant.virtualisation = {
      memorySize = 2048;
      cores = 2;
      # diskSize = "auto";
      graphics = true;

      qemu.options = [
        "-device virtio-vga-gl"
        "-display gtk,gl=on"
      ];
    };

    hardware.graphics.enable = true;
    nixpkgs = {
      hostPlatform = "x86_64-linux";
      config.allowUnfree = true;
    };
    system.stateVersion = "26.11";
  };
}
