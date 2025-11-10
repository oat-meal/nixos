{ config, pkgs, ... }:

{
  users.users.llm = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  networking.hostName = "llm-server";
  system.stateVersion = "25.05";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    git
    curl
    wget
    htop
  ];
}
