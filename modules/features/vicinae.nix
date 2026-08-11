{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.myVicinae =
      inputs.wrapper-modules.lib.wrapPackage
      ({lib, ...}: {
        inherit pkgs;
        package = lib.mkDefault pkgs.vicinae;
      });
  };
}
