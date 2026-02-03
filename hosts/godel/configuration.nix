{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./filesystems.nix
  ];

  networking.hostName = "godel";
  time.timeZone = "America/Denver";

  # Basic admin + SSH (headless-friendly)
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  users.users.efortmeyer = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" ];
    shell = pkgs.zsh;
  };

  # If you prefer NetworkManager on servers you can keep it; otherwise switch to systemd-networkd.
  networking.networkmanager.enable = true;

  # Docker (you mentioned build images definitely)
  virtualisation.docker.enable = true;

  # Useful base packages
  environment.systemPackages = with pkgs; [
    git
    vim
    neovim
    curl
    wget
    jq
    htop
    tmux
    zsh
    btrfs-progs
    cryptsetup
  ];

  # Optional: makes Nix store efficient on Btrfs/SSD
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # Bootloader (adjust if you use systemd-boot instead of GRUB)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Keep state version aligned with your installed NixOS release
  system.stateVersion = "24.11";
}
