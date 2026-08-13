{self, ...}: {
  flake.nixosModules.commonPackages = {pkgs, ...}: {
    imports = [
      self.nixosModules.fish
    ];
    environment.systemPackages = with pkgs; [
      direnv
      devenv
      keepassxc
      libreoffice
      thunderbird

      hardinfo2
      vlc
      vesktop

      loupe
      kdePackages.ark
      kdePackages.dolphin
      kdePackages.spectacle

      kdiff3

      arc-icon-theme

      xwayland-satellite
      tidal-hifi
    ];
  };
}
