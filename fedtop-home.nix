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
    pkg-config
    bolt
    stm32cubemx
    openocd
    jlink
  ];

  home.username = "fedtop";
  home.homeDirectory = "/home/fedtop";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.sessionVariables = {
    NIX_HOME_DERIVATION = "fedtop";
  };
}
