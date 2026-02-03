# Gödel (ex‑Frankenstein) — Homelab Host

Gödel is the homelab system (formerly [Frankenstein](../../docs/frankenstein/README.md)) used for skill-building and self-hosted infra:

- NixOS
- Btrfs (snapshots, compression)
- Headless operation (GPU present only to satisfy BIOS)
- Backups/archives/cold storage
- Docker image builds, GitHub runners (later)
- VPN server (maybe), k8s/k3s experiments (maybe)

## Hardware

- 500GB SSD (fast storage)
- 1TB HDD (cold storage)

## Design Goals

- **SSD = hot path**: OS, `/nix`, `/home`, docker/build cache, active repos
- **HDD = cold path**: `/data/{backups,archives,media,...}`
- No Frankenstein-style bind-mount hacks needed here; prefer mounting HDD at `/data`
- Use Btrfs subvolumes for structure and snapshotting

## Files

- `configuration.nix` — host settings (SSH, users, docker, packages)
- `hardware-configuration.nix` — generated per install; update UUIDs + LUKS mapping
- `filesystems.nix` — Btrfs subvol layout + `/data` mounts (SSD + HDD)

## Recommended Disk Layout (High Level)

### SSD (Btrfs, LUKS encrypted)

Mount `/` using subvolumes:

- `@root` -> `/`
- `@nix` -> `/nix`
- `@home` -> `/home`
- `@var` -> `/var`
- `@docker` -> `/var/lib/docker` (optional but recommended)

Btrfs options:

- `compress=zstd`
- `noatime`

### HDD (Btrfs, LUKS encrypted)

Mount at `/data` with subvolumes:

- `@data` -> `/data`
- `@backups` -> `/data/backups`
- `@archives` -> `/data/archives`
- `@media` -> `/data/media`
- `@snapshots` -> `/data/snapshots` (optional)

Btrfs options:

- `compress=zstd`
- `noatime`
- `autodefrag` (useful for spinning disks)

## Install / Bring-up Checklist

1. Install NixOS (UEFI).
2. Create LUKS containers for SSD + HDD.
3. Create Btrfs filesystems and subvolumes matching `filesystems.nix`.
4. Run `nixos-generate-config` and merge:
   - keep hardware detection bits in `hardware-configuration.nix`
   - use this repo’s `configuration.nix` + `filesystems.nix`
5. Replace UUID placeholders in `hardware-configuration.nix` and `filesystems.nix`.
6. `sudo nixos-rebuild switch`

## Notes

- Keep projects on SSD. HDD is for cold storage only.
- If you want “some folder in home lives on HDD”, prefer a symlink:
  `ln -s /data/archives/something ~/something`
- Avoid committing secrets; use `agenix`/`sops-nix` later if needed.
