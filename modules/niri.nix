{ config, pkgs, lib, ... }:

{
  # Enable Niri Wayland compositor support
  programs.niri.enable = true;

  # Install required environment tools for Wayland sessions
  environment.systemPackages = with pkgs; [
    niri
    xwayland
    wl-clipboard
    wayland-utils
    xdg-utils
    mako  # Wayland-compatible notification daemon
  ];

  # Enable core desktop services and interop with Wayland
  services.dbus.enable = true;
  services.libinput.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-wlr ];

  # Keyring support for GNOME-style secrets and GPG
  services.gnome.gnome-keyring.enable = true;

  # Optional login manager using greetd with TUI frontend
  services.greetd = {
    enable = true;
    settings.default_session.command = ''
      ${pkgs.greetd.tuigreet}/bin/tuigreet --cmd niri
    '';
  };
}
