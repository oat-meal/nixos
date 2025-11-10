{ config, pkgs, ... }:

{
  # User account for the main desktop user
  users.users.chris = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "input" ];
    shell = pkgs.zsh;
  };

  # Enable Zsh globally (required because chris uses it as a shell)
  programs.zsh.enable = true;

  # Define the root file system using Btrfs with a root subvolume
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/".fsType = "btrfs";
  fileSystems."/".options = [ "subvol=@" ];

  # Set the system hostname
  networking.hostName = "desktop-nixos";

  # Set the state version to match the installed NixOS release
  system.stateVersion = "25.05";

  # Bootloader configuration using systemd-boot and EFI
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable AMD CPU microcode updates
  hardware.cpu.amd.updateMicrocode = true;

  # Enable AMD GPU drivers (for 7900XTX / RDNA3)
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Optional kernel parameter for AMD GPU (disables Smart Access Graphics)
  boot.kernelParams = [ "amdgpu.sg_display=0" ];

  # Enable X11 and GDM with Wayland session support (required for Niri)
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # Enable PipeWire audio stack for PulseAudio, JACK, and ALSA compatibility
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable Libinput drivers for mouse, touchpad, and other input devices
  services.libinput.enable = true;

  # Enable Bluetooth and provide a tray icon via Blueman
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Globally available system packages
  environment.systemPackages = with pkgs; [
    neovim             # Preferred editor
    alacritty          # Preferred terminal
    blueman            # Bluetooth manager
    btrfs-progs        # Btrfs file system tools
    util-linux         # Mount and partition tools
    vulkan-tools       # Vulkan diagnostic utilities
    pciutils           # lspci and related tools
    usbutils           # lsusb and USB device inspection
    lm_sensors         # Hardware monitoring (temps, fans, etc.)
  ];

  # Enable OpenGL rendering support
  hardware.opengl.enable = true;

  # Add additional OpenGL/Vulkan libraries for hardware acceleration
  hardware.opengl.extraPackages = with pkgs; [
    vaapiVdpau
    libvdpau-va-gl
  ];

  # Enable NetworkManager for wired and wireless network control
  networking.networkmanager.enable = true;

  # Add fonts for international text, CJK, and emoji support
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # Enable Polkit and GNOME keyring integration
  security.polkit.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;

  # Enable redistributable firmware (Wi-Fi, GPU, etc.)
  hardware.enableRedistributableFirmware = true;

  # Configure a swap file (helpful for hibernation or memory pressure)
  swapDevices = [
    { device = "/swapfile"; }
  ];
}
