{ config, lib, pkgs, ... }:

{
  programs.tmux = {
    package = pkgs.tmux;
    enable = true;
    extraConfig = builtins.readFile ./dotfiles/tmux/tmux.conf;
  };
}

