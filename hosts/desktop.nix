{ config, pkgs, lib, ... }:

{
  # Target system compatibility version (for upgrade safety)
  system.stateVersion = "25.05";

  # Enable flake features globally (required for flake-based installs)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable unfree packages globally (required for Steam, firmware, etc.)
  nixpkgs.config.allowUnfree = true;

  # Localization and timezone
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";

  # Bootloader configuration for UEFI systems using systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem configuration using UUIDs for stability
  fileSystems."/" = {
    device = "UUID=947735dd-986c-4914-be39-e3315253d16c";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/home" = {
    device = "UUID=947735dd-986c-4914-be39-e3315253d16c";
    fsType = "btrfs";
    options = [ "subvol=@home" ];
  };

  fileSystems."/boot" = {
    device = "UUID=1046-3DFA";
    fsType = "vfat";
  };

  # Networking using NetworkManager (Wi-Fi and Ethernet)
  networking.hostName = "desktop-nixos";
  networking.networkmanager.enable = true;

  # Define the desktop user
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;
    ignoreShellProgramCheck = true;
  };

  # System-wide shell support
  programs.zsh.enable = true;

  # Enable Bluetooth and provide GUI support with blueman
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable firmware (for Wi-Fi, AMD GPUs, etc.)
  hardware.enableRedistributableFirmware = true;

  # Essential system tools and utilities
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
