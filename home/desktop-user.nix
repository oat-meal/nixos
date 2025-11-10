{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  home.username = "chris";
  home.homeDirectory = "/home/chris";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    brave
    alacritty
    neovim
    file
  ];
}
