# Gödel (ex‑Frankenstein) — Homelab Host

Gödel is the homelab system (formerly ../../docs/frankenstein/README.md) used for skill-building and self-hosted infra:

- NixOS
- Btrfs (snapshots, compression)
- Headless operation (GPU present only to satisfy BIOS)
- Backups/archives/cold storage
- Docker image builds, GitHub runners (later)
- VPN server (maybe), k8s/k3s experiments (maybe)

> **BIOS quirk:** this board halts at POST if no keyboard is attached. For now,
a spare USB keyboard (or a tiny HID “dummy keyboard” dongle) remains plugged in.

---

## Remote LUKS Unlock (initrd SSH)

- **During stage‑1**, SSH is exposed on **port 2222** to unlock the LUKS root.
- Two ways to reach it:
  1. **Static initrd IP** via kernel param (`ip=…`) and SSH to that IP:

     ```bash
     ssh -p 2222 root@<initrd-ip>
     ```

  2. **DHCP + router DNS** (best effort): udhcpc pushes hostname during stage‑1.
     If the router doesn’t publish hostnames, use a DHCP reservation or a client `/etc/hosts` entry.
- `.local` (mDNS) is available **after** stage‑2 when Avahi starts.

You’ll see a **Gödel-number MOTD** and then an interactive **cryptsetup** prompt.

---

## Headless / Target

- Graphical stack disabled (no X/DM/DE).
- Default target: `multi-user.target`.
- OpenSSH is on for stage‑2 access (keys only).

---

## Zsh + Powerlevel10k

- Declarative Zsh with Oh‑My‑Zsh built‑in plugins only.
- External plugins enabled via NixOS options:
  - `programs.zsh.autosuggestions.enable = true;`
  - `programs.zsh.syntaxHighlighting.enable = true;`
- Prompt powered by Powerlevel10k from the Nix store.
- Config shipped at **`/etc/p10k.zsh`**.
- Switch variant and rebuild:

```nix
shell.p10k.variant = "minimal";  # or "richer"
```

## Package Profiles (enabled on Gödel)

- dev-base (vim/neovim, git/gh, jq/yq, htop)
- cli-qol (fzf, ripgrep, fd, bat, eza, zoxide, sd, hyperfine)
- netops (mtr, nmap, traceroute, inetutils, bind/dig, iperf3, tcpdump, wireshark-cli, netcat)
- containers (docker-compose | podman/podman-compose, kubectl, helm, k9s)
- php (php, composer, common extensions, phpstan, psysh)
- fp-stack (ghc, cabal, stack, HLS, hlint, dotnet-sdk, lean4, agda, idris2, coq)
- k8s-homelab (kind, minikube, kustomize, fluxcd, stern, kubectx/kubens, cni-plugins, cri-tools, containerd, nerdctl)
- vpn-homelab (wireguard-tools, openresolv, qrencode, iproute2, iptables, nftables)

Service enablement (k8s cluster, WireGuard interfaces, etc.) is out of scope here and will be added in future PRs.

## Install / Bring-up (recap)

- Install NixOS, create LUKS + Btrfs (SSD=hot, HDD=cold).
- Clone repo and rebuild:

```nix
nixos-rebuild switch --flake .#godelShow more lines
```

- Reboot; unlock via initrd SSH on port 2222.
- Stage‑2 reachable via normal OpenSSH; shell is Zsh with p10k.

## Notes

- Keep projects on SSD. HDD is for cold storage only.
- If you want “some folder in home lives on HDD”, prefer a symlink:
  `ln -s /data/archives/something ~/something`
- Avoid committing secrets; use `agenix`/`sops-nix` later if needed.
