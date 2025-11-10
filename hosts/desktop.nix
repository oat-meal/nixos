{ config, pkgs, ... }:

{
  # Define the main user
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # Enable Zsh shell
  programs.zsh.enable = true;

  # Define root file system
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType = "btrfs";
  fileSystems."/".options = [ "subvol=@" ];

  # Hostname and state version
  networking.hostName = "desktop-nixos";
  system.stateVersion = "25.05"; # Set to your installed version

  # Bootloader setup
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Microcode and graphics drivers
  hardware.cpu.amd.updateMicrocode = true;

  # Enable AMDGPU driver and add kernel parameter
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  # Enable X11 + Wayland with GDM
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # Enable PipeWire audio stack
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable input drivers
  services.libinput.enable = true;

  # Enable Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # System packages installed globally
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

  # Enable OpenGL (generic flag only)
  hardware.opengl.enable = true;

  # Recommended extra packages for hardware acceleration
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Enable networking
  networking.networkmanager.enable = true;

  # Fonts for GUI
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Polkit and firmware
  security.polkit.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  hardware.enableRedistributableFirmware = true;

  # Swap file (for hibernation or large RAM systems)
  swapDevices = [ { device = "/swapfile"; } ];
}
