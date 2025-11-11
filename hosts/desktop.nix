{ config, pkgs, lib, ... }:

{
  # Target system compatibility version (lock system modules to this release)
  system.stateVersion = "25.05";

  # Enable flake support (required for flake-based system configuration)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow installation of non-free software (e.g., Steam, proprietary drivers)
  nixpkgs.config.allowUnfree = true;

  # Localization settings
  i18n.defaultLocale = "en_US.UTF-8";

  # Set system timezone
  time.timeZone = "America/Chicago";

  # Bootloader configuration for UEFI systems using systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Filesystem configuration using UUIDs for stability
  fileSystems."/" = {
    device = "UUID=8ea2530c-aaee-4a0f-a1f4-0eed4c3ab74a";
    fsType = "btrfs";
  };

  fileSystems."/boot" = {
    device = "UUID=025C-FCOD";
    fsType = "vfat";
  };

  # Set hostname and enable NetworkManager for all network interfaces
  networking.hostName = "desktop-nixos";
  networking.networkmanager.enable = true;

  # Define a regular user account with sudo and device access
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;

    # Suppress shell path warning for Zsh (safe for managed environments)
    ignoreShellProgramCheck = true;
  };

  # Enable Zsh globally for all users
  programs.zsh.enable = true;

  # Enable Bluetooth support (hardware and GUI)
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable access to non-free firmware blobs (required for some Wi-Fi/GPUs)
  hardware.enableRedistributableFirmware = true;

  # Common system utilities installed globally
  environment.systemPackages = with pkgs; [
    git            # Git version control
    wget           # Command-line download tool
    curl           # HTTP client
    btrfs-progs    # Tools for Btrfs filesystem
    zsh            # Z Shell
    neovim         # Terminal-based code editor
    alacritty      # GPU-accelerated terminal emulator
    pciutils       # lspci and other PCI tools
    usbutils       # lsusb and other USB tools
    lsb-release    # For checking distribution information
  ];
}
