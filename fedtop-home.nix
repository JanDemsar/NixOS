{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./home-update.sh);
in
{
  imports = [
    ./zsh.nix
    ./fonts.nix
    ./tmux.nix
    ./nvim.nix
#    ./jlink.nix
  ];

  home.packages = with pkgs; [
    home-update
    nixfmt
    nvd
    roboto
    flac
    zip
    bottom
    jetbrains.clion
    vscode
    atom
    teams
    meson
    ninja
    cmake
    pkg-config
    bolt
    stm32cubemx
    openocd
  ];

  home.username = "fedtop";
  home.homeDirectory = "/home/fedtop";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
