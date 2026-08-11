{
  lib,
  ...
}: {
  flake.lib.forEachHomeUser = users: f:
    lib.mapAttrs f (
      lib.filterAttrs
      (_name: user: user.homeManager.enable)
      users
    );
}
