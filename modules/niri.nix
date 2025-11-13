{ config, pkgs, lib, ... }:

{
  programs.niri.enable = true;

  environment.systemPackages = with pkgs; [
    niri
    xwayland
    xwayland-satellite
    wl-clipboard
    wayland-utils
    xdg-utils
    mako
  ];

  services.dbus.enable = true;
  services.libinput.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-wlr ];
  };

  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        user = "chris";
        command = "${pkgs.niri}/bin/niri";
      };
    };
  };
}

