{ config, pkgs, ... }:

let
  home-update = pkgs.writeShellScriptBin "home-update" (builtins.readFile ./home-update.sh);
in
{
  imports = [
    ./zsh.nix
    ./fonts.nix
  ];

  home.packages = with pkgs; [
    home-update
    nixfmt
    nvd
    roboto
    flac
    zip
    bottom
    lazygit
    jetbrains.clion
  ];

  home.username = "fedtop";
  home.homeDirectory = "/home/fedtop";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
}
