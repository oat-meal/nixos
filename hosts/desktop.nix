{ config, pkgs, lib, ... }:

{
  ########################################
  ## System Core
  ########################################

  system.stateVersion = "25.05";
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  ########################################
  ## Locale & Time
  ########################################

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";

  ########################################
  ## Bootloader (UEFI + systemd-boot)
  ########################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ########################################
  ## Filesystem Configuration
  ########################################
  # EFI partition: /dev/nvme2n1p1 (FAT32, 2GiB, flags boot,esp)
  # Root partition: /dev/nvme2n1p2 (Btrfs with subvols @, @home, @nix, @log, @swap)

  fileSystems."/" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291ef37587ec";
  fsType = "btrfs";
  options = [ "subvol=@" ];
 };

 fileSystems."/boot" = {
  device = "UUID=4BE5-47A3";
  fsType = "vfat";
 };

 fileSystems."/home" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291ef37587ec";
  fsType = "btrfs";
  options = [ "subvol=@home" ];
 };

 fileSystems."/nix" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291ef37587ec";
  fsType = "btrfs";
  options = [ "subvol=@nix" ];
 };

 fileSystems."/var/log" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291ef37587ec";
  fsType = "btrfs";
  options = [ "subvol=@log" ];
 };

 fileSystems."/swap" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291ef37587ec";
  fsType = "btrfs";
  options = [ "subvol=@swap" ];
};

#  Optional — if you want your swap file on the @swap subvolume
#  swapDevices = [
#   { file = "/swap/swapfile"; }
# ];

  ########################################
  ## Storage Pool (Btrfs RAID: NVME_Pool)
  ########################################

  # Mount the main storage pool at /storage
  fileSystems."/storage" = {
  device = "UUID=5462bbac-d14a-4189-8ca8-aa07cd026c86";
  fsType = "btrfs";
  options = [ "rw" "ssd" "relatime" "space_cache=v2" "compress=zstd" "subvol=/" ];
  };

  ########################################
  ## Environment Variables (GLOBAL)
  ########################################
  ## These must be here. They ensure:
  ## - greetd passes correct env to Niri
  ## - Niri passes correct env to Xwayland
  ## - Steam sees both X11 + Wayland backends
  ## - NO manual DISPLAY overrides (!!)

  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    SDL_VIDEODRIVER = "wayland";
  };

  ########################################
  ## Hostname & Networking
  ########################################

  networking.hostName = "desktop-nixos";
  networking.networkmanager.enable = true;
  # for build error - fix and remove later
  services.logrotate.enable = false;

  ########################################
  ## User Configuration
  ########################################

  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  programs.zsh.enable = true;

  ########################################
  ## Hardware & Services
  ########################################

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  hardware.enableRedistributableFirmware = true;

 ########################################
 ## Fonts
 ########################################

fonts = {
  packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];
};


  ########################################
  ## Global Packages
  ########################################

  environment.systemPackages = with pkgs; [
    git
    wget
    yazi
    curl
    fuzzel
    xorg.libXcursor
    xorg.libX11
    xorg.libXrandr
    bibata-cursors
    btrfs-progs
    zsh
    neovim
    alacritty
    pciutils
    usbutils
    lsb-release
    xwayland
    xwayland-satellite
    #testing
    libpulseaudio
    libudev0-shim
    alsa-lib
    alsa-plugins
    ffmpeg
    libGL
    libdrm
    libxkbcommon
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    wayland
    xorg.libX11
    xorg.libXrandr
    xorg.libxcb
    xorg.libXext
    glib
    gtk3
  ];
}
