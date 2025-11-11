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

  fileSystems = {
    "/" = {
      device = "UUID=8ea2530c-aaee-4a0f-a1f4-0eed4c3ab74a";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

    "/boot" = {
      device = "UUID=025C-FCOD";
      fsType = "vfat";
    };

    "/home" = {
      device = "UUID=8ea2530c-aaee-4a0f-a1f4-0eed4c3ab74a";
      fsType = "btrfs";
      options = [ "subvol=@home" ];
    };

    "/nix" = {
      device = "UUID=8ea2530c-aaee-4a0f-a1f4-0eed4c3ab74a";
      fsType = "btrfs";
      options = [ "subvol=@nix" ];
    };

    "/var/log" = {
      device = "UUID=8ea2530c-aaee-4a0f-a1f4-0eed4c3ab74a";
      fsType = "btrfs";
      options = [ "subvol=@log" ];
    };
  };

  # Swap file will live on /swap/swapfile (inside subvol=@swap)
  swapDevices = [
    { file = "/swap/swapfile"; }
  ];

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
