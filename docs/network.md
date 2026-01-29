# Network Overview

This document describes the basic network layout for the homelab machines in
**incomplete-stack**. The goal is clarity and future-proofing, not rigidity. As
the environment evolves, so will this file.

## Machines

- **Samson**
  OS: Ubuntu
  Role: workstation / general compute
  Network: DHCP or static LAN assignment (TBD)

- **Hiram**
  OS: Debian
  Role: primary workstation, future SSH/VPN pivot point
  Network: stable LAN static IP (planned)

- **Gödel**
  OS: NixOS
  Role: learning node — Docker builds, Nix flakes, Nexus, storage
  Network: LAN static IP preferred for registry + SSH consistency

## Services (Planned or Potential)

- **Nexus Repository / Docker Registry** on Gödel
- **Backup endpoints** across LAN
- **VPN gateway or hub** (WireGuard likely)
- **Metrics & logs** (lightweight self-hosted options TBD)
- **Container orchestration** (k3s experiments)

## Layout (Initial Concept)

Future expansion may include:

- a Raspberry Pi utility node
- NAS or dedicated storage
- a lightweight reverse proxy or ingress layer
- isolated VLANs for experiments

This file is a living document and will grow organically with the homelab.
