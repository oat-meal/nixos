{ config, pkgs, ... }:

{
  # Set the username and home path
  home.username = "chris";
  home.homeDirectory = "/home/chris";

  # Set the Home Manager version (matches your NixOS version)
  home.stateVersion = "25.05";

  # Enable Zsh and configure oh-my-zsh with a theme
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  #  autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster"; # Or "robbyrussell", "bira", etc.
    };
  };

  # Enable Git with sensible defaults
  programs.git = {
    enable = true;
    userName = "Chris"; # Change to your name
    userEmail = "you@example.com"; # Change to your Git email
  };

  # Enable Neovim with plugins (optional)
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      vim-nix
      vim-airline
    ];
  };

  # Optional: Enable Alacritty terminal with config
  programs.alacritty = {
    enable = true;
    settings = {
      window.opacity = 0.9;
      font.size = 12;
    };
  };

  # Fonts (for zsh themes and terminals)
  fonts.fontconfig.enable = true;

  # Useful CLI tools
  home.packages = with pkgs; [
    bat
    eza
    htop
    ripgrep
    fd
    unzip
    zip
    wget
    curl
    jq
    git-crypt
  ];

  # Enable GPG agent for Git signing, SSH, etc.
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3"; # Or "qt", "tty"
    enableSshSupport = true;
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
