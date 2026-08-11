{
  self,
  inputs,
  lib,
  ...
}: {
  flake.nixosModules.sddm = {lib, ...}: {
    imports = [
      inputs.silent-sddm.nixosModules.default
    ];
    programs.silentSDDM = {
      enable = true;
      theme = "catppuccin-mocha";
      settings = {
        "LockScreen.Message".icon = "";
        "LockScreen.Clock".font-family = "DejaVu Sans Mono";
        "LockScreen.Date".font-family = "DejaVu Sans Mono";
        "LockScreen.Message".font-family = "DejaVu Sans Mono";
        "LoginScreen.LoginArea.Username".font-family = "DejaVu Sans Mono";
        "LoginScreen.LoginArea.PasswordInput" = {
          font-family = "DejaVu Sans Mono";
          border-radius-left = 2;
          border-radius-right = 2;
        };
        "LoginScreen.LoginArea.LoginButton" = {
          font-family = "DejaVu Sans Mono";
          border-radius-left = 2;
          border-radius-right = 2;
        };
        "LoginScreen.LoginArea.Spinner".font-family = "DejaVu Sans Mono";
        "LoginScreen.LoginArea.WarningMessage".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Buttons".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Popups".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Session".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Layout".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Keyboard".font-family = "DejaVu Sans Mono";
        "LoginScreen.MenuArea.Power".font-family = "DejaVu Sans Mono";
        "Tooltips".font-family = "DejaVu Sans Mono";
      };
    };
    services.displayManager.sddm = {
      enable = true;
    };
  };
}
