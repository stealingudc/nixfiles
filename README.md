# My NixOS Config
- Desktop: Niri + Noctalia
- Shell: fish
- Terminal: kitty
- Launcher: vicinae
- Theme: Dracula (Stylix)

Includes sensible (?) configs for tmux, nvim.

## Hosts
- `basilisk` -- my home machine, sporting an NVIDIA RTX 3060 Ti, using open drivers.

## Usage
- To run a minimal version of the config (Niri wrapper): `nix run github:stealingudc/nixfiles#basilisk-base`.

- For a full version of the config (Niri wrapper, may conflict with running host processes): `nix run github:stealingudc/nixfiles#basilisk-full`.

- To run a dedicated VM of the full version: `nix run github:stealingudc/nixfiles#basilisk-full-vm`.

- To build, `sudo nixos-rebuild switch --flake github:stealingudc/nixfiles#basilisk-full`.

Note that, for a fully-featured config, downloads can exceed 20+ gigs.

#### ⚠️ Non-NixOS hosts

If you're not running NixOS, you will need to use nixGL, due to [Niri being weird](https://niri-wm.github.io/niri/Getting-Started.html#nixosnix):

`nix run --impure github:guibou/nixGL -- <command>`

For example, `nix run --impure github:guibou/nixGL -- nix run github:stealingudc/nixfiles#basilisk-base`.

#### Fedora and libostree-based distros

If your host distro doesn't allow installing `nix` (`/` being read-only), you may use [nix-toolbox](https://thrix.github.io/nix-toolbox/).

## Notes
This repo is not reflective of my skills as a programmer :3

The dendritic pattern is truly magical.
