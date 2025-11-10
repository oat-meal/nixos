{ config, pkgs, ... }:

{
  # Enable Niri Wayland compositor
  programs.niri.enable = true;

  # Required tools for full Wayland session with XWayland support
  environment.systemPackages = with pkgs; [
    niri
    foot
    mako
    slurp
    grim
    wl-clipboard
    wlr-randr
    xdg-utils
    xwayland
    xwayland-satellite # <-- Required for X11 apps under Niri
  ];

  # Enable dbus and seatd (for Wayland session management)
  services.dbus.enable = true;
  services.seatd.enable = true;

  # Optional: use greetd to auto-login to Niri
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "niri";
        user = "chris";
      };
    };
  };

  # Start xwayland-satellite as a user service
  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "xwayland-satellite for X11 under Wayland";
      After = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.xwayland-satellite}/bin/xwayland-satellite";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Let home-manager start user services
  home-manager.users.chris = {
    systemd.user.startServices = true;
  };

  # Input support
  services.libinput.enable = true;

  # Environment for Wayland-native apps
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    SDL_VIDEODRIVER = "wayland";
  };
}
