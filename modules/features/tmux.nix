{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.tmux = {pkgs, ...}: {
    programs.tmux = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myTmux;
    };
  };

  perSystem = {pkgs, ...}: {
    packages.myTmux = inputs.wrapper-modules.wrappers.tmux.wrap {
      inherit pkgs;

      modeKeys = "vi";
      statusKeys = "vi";
      vimVisualKeys = true;
      prefix = "C-a";

      configAfter = ''
        set-environment -gF PATH "${pkgs.tmux}/bin:#{PATH}"
      '';

      plugins = let
        draculaTheme = pkgs.tmuxPlugins.dracula.overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              patchShebangs --build $out
            '';
        });
        dracula = pkgs.writeShellScript "dracula" ''
          export PATH="${pkgs.tmux}/bin:$PATH"
          exec ${draculaTheme}/share/tmux-plugins/dracula/dracula.tmux
        '';
        sessionx = pkgs.tmuxPlugins.tmux-sessionx.overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              patchShebangs --build $out
            '';
        });
        sessionxPicker = pkgs.writeShellScript "sessionx-picker" ''
          export PATH="${pkgs.tmux}/bin:$PATH"
          exec ${sessionx}/share/tmux-plugins/sessionx/scripts/sessionx.sh
        '';
        resurrect = pkgs.tmuxPlugins.resurrect.overrideAttrs (old: {
          postInstall =
            (old.postInstall or "")
            + ''
              patchShebangs --build $out
            '';
        });
        resurrectEntry = pkgs.writeShellScript "resurrect-entry" ''
          export PATH="${pkgs.tmux}/bin:$PATH"
          exec ${resurrect}/share/tmux-plugins/resurrect/resurrect.tmux
        '';
        resurrectSave = pkgs.writeShellScript "resurrect-save" ''
          export PATH="${pkgs.tmux}/bin:$PATH"
          exec ${resurrect}/share/tmux-plugins/resurrect/scripts/save.sh
        '';
        resurrectRestore = pkgs.writeShellScript "resurrect-restore" ''
          export PATH="${pkgs.tmux}/bin:$PATH"
          exec ${resurrect}/share/tmux-plugins/resurrect/scripts/restore.sh
        '';
      in [
        {
          plugin = dracula;
          rtp = "${dracula}";
        }
        {
          plugin = sessionx;
          configAfter = "bind-key o run-shell ${sessionxPicker}";
        }
        {
          plugin = resurrect;
          rtp = "${resurrectEntry}";
          configAfter = ''
            bind-key C-s run-shell ${resurrectSave}
            bind-key C-r run-shell ${resurrectRestore}
          '';
        }
      ];
    };
  };
}
