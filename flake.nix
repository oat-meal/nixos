{
  description = "NixOS configuration for desktop system using Niri and Steam";

  inputs = {
    # Main NixOS package set (25.05 stable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # Nixpkgs for unstable overlays or optional packages (not used by default)
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager for user-level configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Optional: nixpkgs-wayland overlays (used by some Wayland tools)
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixpkgs-wayland, ... }:
    let
      # Define system architecture
      system = "x86_64-linux";

      # Import shared overlays or custom packages (optional)
      overlays = [
        nixpkgs-wayland.overlay
        # Add custom overlays here if needed
      ];

      # Construct the base NixOS module environment
      mkNixosSystem = modules: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit system;
          # Pass all flake inputs to modules (optional)
          inputs = { inherit self nixpkgs nixpkgs-unstable home-manager nixpkgs-wayland; };
        };
        modules = [
          # Core system and hardware settings
          ./hosts/desktop.nix

          # Compositor and Wayland session (Niri)
          ./modules/niri.nix

          # Steam and gaming tools
          ./modules/steam.nix

          # Enable home-manager as a NixOS module
          home-manager.nixosModules.home-manager

          # Home-manager config for the user "chris"
          {
            home-manager.users.chris = import ./home/desktop-user.nix;
          }

          # Start user services automatically (required for systemd user units)
          {
            home-manager.extraSpecialArgs = {
              inherit system;
            };
            home-manager.backupFileExtension = "hm_bak";
          }
        ];
      };
    in
    {
      # Define system configurations (single machine setup)
      nixosConfigurations.desktop-nixos = mkNixosSystem [];
    };
}
