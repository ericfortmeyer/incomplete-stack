# incomplete-stack

A deliberately imperfect collection of configs, scripts, and system definitions
for my evolving homelab machines — Samson (Ubuntu), Hiram (Debian), and Gödel
(NixOS).

Inspired by Gödel’s Incompleteness Theorem, this repo embraces the idea that no
system can ever be fully complete — and that’s part of the fun. This monorepo
holds the moving pieces of a home infrastructure that grows, adapts, and stays
intentionally unfinished.

---

## Repo Layout

- `nixos/flake.nix` — NixOS flake (hosts, modules, profiles)
- `nixos/hosts/` — per‑host configs (e.g., `godel.nix`)
- `nixos/modules/` — reusable modules
  - `profiles/` — package profiles (CLI/QoL, netops, containers, PHP, FP stack, k8s, VPN, etc.)
  - `shell/p10k.nix` — Powerlevel10k presets (`minimal` / `richer`)
- `hosts/` — host‑specific docs, authorized keys, bootstrap assets
- `docs/` — notes and long‑form docs

---

## Quick Start (Gödel)

```zsh
# From a Nix-enabled workstation
git clone <this-repo>
cd incomplete-stack/nixos

# Switch Gödel to HEAD (via SSH or console)
nixos-rebuild switch --flake .#godel
```

Boot flow: initrd SSH is enabled for remote LUKS unlock. During early boot,
you can connect to the initrd (port 2222) and enter the passphrase remotely.

## Initrd SSH (remote unlock)

- Connect during stage‑1:
- If you prefer static addressing for initrd, set the ip=... kernel param in godel.nix.
.local (mDNS) works only after the OS boots (Avahi in stage‑2). For stage‑1,
- use a static IP, a router DNS reservation, or a client /etc/hosts entry.

```zsh
ssh -p 2222 root@<initrd-ip>

# you'll see the Gödel-number MOTD, then a cryptsetup passphrase promp
```

## Hosts

- [Gödel](./hosts/godel/README.md)
- [Hiram](./hosts/hiram/README.md)
- [Samson](./hosts/samson/README.md)

## Documentation

- [Frankenstein](./docs/frankenstein/README.md)
- [Network](./docs/network.md)
- [Philosophy](./docs/philosophy.md)
