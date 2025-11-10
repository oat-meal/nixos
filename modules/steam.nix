{ config, pkgs, ... }:

{
  # Enable the official Steam package
  programs.steam = {
    enable = true;

    # Optional: run Steam inside a Gamescope session
    gamescopeSession.enable = true;

    # Allow incoming connections for Steam Remote Play
    remotePlay.openFirewall = true;

    # Open firewall ports for hosting dedicated servers (optional)
    dedicatedServer.openFirewall = true;
  };

  # Enable full OpenGL and Vulkan support (both 64-bit and 32-bit)
  hardware.opengl = {
    enable = true;

    # DRI (Direct Rendering Interface) support
    driSupport = true;
    driSupport32Bit = true;

    # Vulkan drivers for AMD GPU (RDNA3)
    extraPackages = with pkgs; [
      amdvlk            # AMD's proprietary Vulkan driver (you may also try vulkan-radeon)
      libvdpau-va-gl    # VDPAU wrapper for VA-API
      vaapiVdpau        # VA-API to VDPAU translation
    ];

    # 32-bit variants required for legacy and Proton games
    extraPackages32 = with pkgs.pkgsi686Linux; [
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  # Make sure firmware is available for graphics and input devices
  hardware.enableAllFirmware = true;

  # PulseAudio 32-bit support is needed for Proton voice/audio in some games
  hardware.pulseaudio.support32Bit = true;

  # Steam udev rules (for controllers, Steam Deck input, etc.)
  services.udev.packages = with pkgs; [ steam ];

  # Recommended environment variables for Steam under Wayland + Proton
  environment.sessionVariables = {
    STEAM_FORCE_DESKTOPUI_SCALING = "1";  # Improves UI scaling under Wayland
    LIBGL_ALWAYS_SOFTWARE = "0";          # Disable software GL (force GPU)
    AMD_VULKAN_ICD = "RADV";              # Use open-source Vulkan driver by default
    VK_ICD_FILENAMES = "${pkgs.vulkan-loader}/etc/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # Custom Proton support
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "$HOME/.steam/root/compatibilitytools.d";
  };

  # System packages for gaming experience
  environment.systemPackages = with pkgs; [
    steam                 # Main Steam client
    protonup-qt           # GUI app to install/manage Proton GE versions
    vulkan-tools          # Useful for testing Vulkan support (e.g., vulkaninfo)
    mangohud              # In-game performance overlay (toggle with F12 by default)
    gamemode              # Dynamically boosts CPU/GPU performance for games
    gamescope             # Optional: nested fullscreen game window manager
  ];

  # Enable GameMode service (Steam auto-detects this to optimize game performance)
  programs.gamemode.enable = true;

  # Open required network ports for Steam services (optional but recommended)
  networking.firewall = {
    allowedTCPPorts = [ 27036 27037 ];   # Remote Play, Steam Link
    allowedUDPPorts = [ 27031 27036 ];   # Game streaming and multiplayer
  };
}
