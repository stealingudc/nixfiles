{
  self,
  inputs,
  ...
}: {
  # minimal set of "demo" packages
  flake.nixosModules.basiliskBasePackages = {...}: {
    imports = [
      self.nixosModules.niri
      self.nixosModules.stylix
      self.nixosModules.tmux
    ];
  };

  # basilisk-base -- to be used with `nix run <path-to-flake>#basilisk-base`
  flake.nixosConfigurations.basilisk-base = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.basiliskConfiguration
      self.nixosModules.basiliskBasePackages
    ];
  };

  flake.nixosModules.basiliskPackages = {pkgs, ...}: {
    imports = [
      self.nixosModules.basiliskBasePackages
      self.nixosModules.steam
      self.nixosModules.nvim
    ];
    environment.systemPackages = with pkgs; [
      vim
      self.packages.${pkgs.stdenv.hostPlatform.system}.myKitty
    ];
  };

  # basilisk-full -- to be applied with `nixos-rebuild switch <path-to-flake>#basilisk-full`
  # alternatively can be `nix run`'d, but expect a huge download size
  flake.nixosConfigurations.basilisk-full = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.basiliskConfiguration
      self.nixosModules.basiliskPackages
      self.nixosModules.commonPackages
    ];
  };

  flake.nixosConfigurations.basilisk-full-vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.basiliskVMConfiguration
      self.nixosModules.basiliskPackages
      self.nixosModules.commonPackages
    ];
  };

  perSystem = {
    pkgs,
    self',
    lib,
    ...
  }: {
    # patched runnables for basilisk
    packages.basilisk-base = let
      systemPackages = self.nixosConfigurations.basilisk-base.config.environment.systemPackages;
    in
      pkgs.writeShellScriptBin "basilisk-base" ''
        export PATH="${pkgs.lib.makeBinPath systemPackages}:$PATH"
        exec ${lib.getExe self'.packages.myNiri}
      '';

    packages.basilisk-full = let
      systemPackages = self.nixosConfigurations.basilisk-full.config.environment.systemPackages;
    in
      pkgs.writeShellScriptBin "basilisk-full" ''
        export PATH="${pkgs.lib.makeBinPath systemPackages}:$PATH"
        exec ${lib.getExe self'.packages.myNiri}
      '';

    packages.basilisk-full-vm = self.nixosConfigurations.basilisk-full-vm.config.system.build.vm;
  };
}
