# nixos
Nixos configurations
# NixOS Flake: Modular Desktop and Server Configuration

This repository contains a flake-based, modular NixOS configuration supporting both:

- A desktop system (`desktop-nixos`)
- A server node (`llmServer`) for future LLM development

It uses:
- NixOS 25.05
- Nix flakes
- Home Manager
- `nixpkgs-wayland` overlay for Wayland-native packages
- Modular Nix structure for easy maintenance

---

## Directory Structure

```text
.
├── flake.nix
├── hosts/
│   ├── desktop.nix
│   └── server.nix
├── home/
│   ├── desktop-user.nix
│   └── server-user.nix
├── modules/
│   ├── niri.nix
│   └── steam.nix
