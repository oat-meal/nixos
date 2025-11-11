{ config, pkgs, ... }:

{
  # Define user identity and state version for Home Manager
  home.username = "chris";
  home.homeDirectory = "/home/chris";
  home.stateVersion = "25.05";

  # Preferred tools for shell and editor
  programs.neovim.enable = true;
  programs.alacritty.enable = true;

  # Zsh shell with popular community enhancements
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
    };
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };

  # Enable GPG agent with GTK-based pin entry
  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gtk2;
    # Optionally, add extraConfig, SSH support, etc.
  };

  # User-level packages managed via Home Manager
  home.packages = with pkgs; [
    firefox
    brave
    unzip
    htop
    ripgrep
  ];
}
