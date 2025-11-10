{ config, pkgs, ... }:

{
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  networking.hostName = "desktop-nixos";
  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.cpu.amd.updateMicrocode = true;

  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  services.libinput.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    alacritty
    blueman
    btrfs-progs
    util-linux
    vulkan-tools
    pciutils
    usbutils
    lm_sensors
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [ mesa.drivers vaapiVdpau libvdpau-va-gl ];
  };

  networking.networkmanager.enable = true;

  fonts.fonts = with pkgs; [ noto-fonts noto-fonts-cjk noto-fonts-emoji ];

  security.polkit.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  hardware.enableRedistributableFirmware = true;

  swapDevices = [ { device = "/swapfile"; } ];
}
