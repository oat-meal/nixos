{ config, pkgs, ... }:

{
  # Specify the default NixOS release for compatibility
  system.stateVersion = "25.05";

  # Enable experimental features needed for flake support
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Localization
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/Chicago";

  # Bootloader setup for UEFI systems
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File system definitions — assumes Btrfs root and separate boot
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "btrfs";
    options = [ "subvol=@" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  # Enable and manage network via NetworkManager
  networking.hostName = "desktop-nixos";
  networking.networkmanager.enable = true;

  # Define the primary user account
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "audio" "video" ];
    shell = pkgs.zsh;

    # Required to suppress warnings if Zsh isn't globally enabled yet
    ignoreShellProgramCheck = true;
  };

  # System-wide shell support
  programs.zsh.enable = true;

  # Enable Bluetooth and management GUI
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable installation of proprietary firmware (e.g. for Wi-Fi, AMD GPU)
  hardware.enableRedistributableFirmware = true;

  # Base system tools useful for diagnostics and editing
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
