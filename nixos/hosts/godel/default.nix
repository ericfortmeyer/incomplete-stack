{
  imports = [
    ../../modules
    ./cpu.nix
    ./docker-buildx.nix
    ./docker-registry.nix
    ./docker-storage.nix
    ./efortmeyer.nix
    ./filesystems.nix
    ./firmware.nix
    ./grub.nix
    ./initrd.nix
    ./kernel.nix
    ./networking.nix
    ./time.nix
    ./yoke.nix
  ];
}
