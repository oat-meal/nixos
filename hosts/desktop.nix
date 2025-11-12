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
 ## Filesystem Configuration (Final)
 ########################################

 fileSystems."/" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291faf37587c";
  fsType = "btrfs";
  options = [ "subvol=@" ];
 };

 fileSystems."/boot" = {
  device = "UUID=4BE5-47A3";
  fsType = "vfat";
 };

 fileSystems."/home" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291faf37587c";
  fsType = "btrfs";
  options = [ "subvol=@home" ];
 };

 fileSystems."/nix" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291faf37587c";
  fsType = "btrfs";
  options = [ "subvol=@nix" ];
 };

 fileSystems."/var/log" = {
  device = "UUID=547e9d27-e12b-48a7-a60c-291faf37587c";
  fsType = "btrfs";
  options = [ "subvol=@log" ];
 };

# Optional — if you want your swap file on the @swap subvolume
# swapDevices = [
#  { file = "/swap/swapfile"; }
# ];

  ########################################
  ## Hostname & Networking
  ########################################

  networking.hostName = "desktop-nixos";
  networking.networkmanager.enable = true;

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
  ## Global Packages
  ########################################

  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    btrfs-progs
    zsh
    neovim
    alacritty
    pciutils
    usbutils
    lsb-release
  ];
}
