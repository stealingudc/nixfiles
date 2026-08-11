{self, ...}: {
  flake.nixosModules.fish = {
    config,
    pkgs,
    lib,
    ...
  }: {
    config.programs.fish = {
      interactiveShellInit = ''
        set fish_greeting
      '';

      shellInit = ''
        set -Ux EDITOR 'vim'
      '';

      shellAliases = {
        ls = "${(lib.getExe pkgs.eza)} --icons";
        lsa = "${(lib.getExe pkgs.eza)} --icons -la";
      };
    };

    config.programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]] then
            shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
            exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };

    config.home-manager.users = self.lib.forEachHomeUser config.my.users (
      _: _: {
        home.file.".config/fish/functions/fish_greeting.fish".text = ''
          function fish_greeting
            ${(lib.getExe pkgs.ufetch)}
          end
        '';

        home.file.".config/fish/functions/nix-rebuild.fish".text = ''
          function nix-rebuild
              if test (count $argv) -eq 0
                  echo "Usage: nix-rebuild <flake-target>"
                  return 1
              end

              set flake_target $argv[1]
              sudo --preserve-env NIXPKGS_ALLOW_UNFREE=1 nixos-rebuild switch --impure --flake $flake_target
          end
        '';

        home.file.".config/fish/config.fish".text = ''
          if status is-interactive
              alias ls="${(lib.getExe pkgs.eza)} --icons"
              alias lsa="${(lib.getExe pkgs.eza)} --icons -la"
              alias lsl="${(lib.getExe pkgs.eza)} --icons -l"
          end

        '';
      }
    );
  };
}
