{ config, pkgs, lib, ... }:

let
  # A helper: optional boolean to install Steam & gaming tools
  gamingEnabled = true;  # set to false if you don’t want Steam/gaming
in

{
  # Only apply gaming settings if enabled
  config = lib.mkIf gamingEnabled {
    # Service: Steam
    services.steam = {
      enable = true;
      # any steam‑specific settings go here
      # e.g., extraOverlayPackages = [ pkgs.someGame ];
    };

    # Graphics & drivers section
    # ------------------------------------------------
    # Remove old hardware.opengl.driSupport (no longer effective) :contentReference[oaicite:1]{index=1}
    # Instead use hardware.graphics
    hardware.graphics = {
      enable = true;                # Enables graphics drivers
      enable32Bit = true;           # Optional: enable 32‑bit libs if needed for Steam
      extraPackages = with pkgs; [
        mesa.drivers
        vaapiVdpau
        libvdpau‑va‑gl
      ];
    };

    # Video driver for X/Wayland (if applicable)
    services.xserver.videoDrivers = [ "amdgpu" ];
    # If you have kernel params for GPU, you can still include them:
    boot.kernelParams = lib.mkForce [
      "amdgpu.sg_display=0"
    ];

    # Firmware + unfree support
    # If you need non‑free drivers/firmware, ensure allowUnfree is set elsewhere
    nixpkgs.config.allowUnfree = true;  # ensure in your flake.nix or top config

    # Other settings for gaming environment (optional)
    environment.systemPackages = with pkgs; [
      steam
      wine
      lutris
    ];

    # Any other overrides or modules
    # ...
  }; # end mkIf
}
