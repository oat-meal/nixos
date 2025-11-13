{ config, pkgs, lib, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;


  extraPackages = with pkgs; [
    # Audio
    libpulseaudio
    alsa-lib
    # compatibility
    gamescope
    # Video / Input
    libudev0-shim
    libdrm
    libxkbcommon
    vulkan-loader
    vulkan-tools

    # X11
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXext
    xorg.libxcb

    # Wayland
    wayland
    wayland-protocols

    # Toolkits
    gtk3
    SDL2
  ];

};

  # Optional: support custom proton builds
  environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS =
    "$HOME/.steam/root/compatibilitytools.d";
}

