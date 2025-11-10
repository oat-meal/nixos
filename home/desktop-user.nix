{ config, pkgs, ... }:

{
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
