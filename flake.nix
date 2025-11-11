{
  # Top-level metadata and configuration for this NixOS system flake.
  description = "NixOS desktop configuration with Niri compositor and Steam, using Home Manager.";

  # Define all external inputs required to build the system.
  inputs = {
    # Stable version of the Nix Packages collection (NixOS 25.05)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Unstable nixpkgs, optionally used for newer software or overlays
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager allows per-user configuration using Nix, integrated with system
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Community overlays for Wayland-related software, useful for compositors like Niri
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  # The outputs define one or more system configurations using these inputs
  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixpkgs-wayland, ... }:
    let
      # Target architecture of the system. Most desktops/laptops use x86_64.
      system = "x86_64-linux";

      # Load additional overlays like nixpkgs-wayland
      overlays = [ nixpkgs-wayland.overlay ];

      # Define a helper function for creating NixOS systems using modular input
      mkSystem = modules: nixpkgs.lib.nixosSystem {
        inherit system;

        # Make flake inputs available to imported modules
        specialArgs = {
          inherit system;
          inputs = {
            inherit self nixpkgs nixpkgs-unstable home-manager nixpkgs-wayland;
          };
        };

        # List of NixOS module files to include in the system
        modules = modules;
      };
    in
    {
      # Define the actual machine configuration using the mkSystem helper
      nixosConfigurations.desktop-nixos = mkSystem [
        # Hardware and base system config
        ./hosts/desktop.nix

        # Optional module: Wayland compositor (Niri)
        ./modules/niri.nix

        # Optional module: Gaming environment (Steam, Wine, Lutris)
        ./modules/steam.nix

        # Integrate Home Manager as a NixOS module
        home-manager.nixosModules.home-manager

        # Define user-specific Home Manager configuration
        {
          home-manager.users.chris = import ./home/desktop-user.nix;
        }

        # Extra args and config for Home Manager
        {
          home-manager.extraSpecialArgs = { inherit system; };
          home-manager.backupFileExtension = "hm_bak";
        }
      ];
    };
}
