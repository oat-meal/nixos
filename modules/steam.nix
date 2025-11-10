{ config, pkgs, ... }:

{
  programs.steam.enable = true;

  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    steam-run
    mangohud
  ];
}
