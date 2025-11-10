{
  description = "Modular NixOS system with desktop and server roles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, nixpkgs-wayland, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ nixpkgs-wayland.overlay ];
      };
    in {
      nixosConfigurations = {
        desktop-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/desktop.nix
            ./modules/niri.nix
            ./modules/steam.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.chris = import ./home/desktop-user.nix;
            }
          ];
        };

        llmServer = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/server.nix

            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.llm = import ./home/server-user.nix;
            }
          ];
        };
      };
    };
}
