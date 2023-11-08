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
    bolt
    unstable.stm32cubemx
    openocd
    nmap
    dpkg
    putty
    unstable.minicom
    docker

    # dev
    unstable.glibc
    pkg-config
    jlink
    stlink
    unstable.gdb
  ];

  home.username = "jandemsar";
  home.homeDirectory = "/home/jandemsar";
  home.stateVersion = "22.11";
  programs.home-manager.enable = true;
  home.sessionVariables = {
    NIX_HOME_DERIVATION = "jandemsar";
  };
}
