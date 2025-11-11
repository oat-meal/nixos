{ config, pkgs, lib, ... }:

{
  # Enable Steam with necessary firewall ports for streaming and servers
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # Enable 32-bit OpenGL support required for Proton and older games
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  # Install additional gaming tools and runtime libraries
  environment.systemPackages = with pkgs; [
    steam
    wineWowPackages.staging  # Latest 64/32-bit Wine packages
    lutris                   # Game launcher and Wine frontend
    mangohud                 # Real-time game performance overlay
  ];
}
