# Hiram — Primary Dev Workstation (projects/b + projects/ericfortmeyer)

Hiram is the main dev workstation for:

- B/projects dev work (user: `eric`)
- Personal projects (user: `efortmeyer`)
- Debian 12
- Docker Compose services run locally on the machine (per-project; repo provides compose)
- VS Code installed via Microsoft APT repo
- NVM installed for both users

> NOTE: Hiram was originally planned as a mini workstation purchase, but the final direction is:
> **maximize performance + cooling + upgradability** (tower workstation, standard PSU, easy upgrades).

## Goals

- Strong sustained CPU performance (builds/tests/containers)
- Simple disk layout (no Frankenstein bind-mount approach)
- LUKS encryption on the OS SSD
- Reproducible workstation bootstrap via `incomplete-stack`

## Users / Separation

- `efortmeyer` — personal
- `eric` — projects/B work
- Both users need:
  - VS Code
  - Docker access
  - NVM + a default Node version

## What This Repo Manages

- Baseline OS packages (apt)
- Adding MS VS Code repo (`/etc/apt/sources.list.d/vscode.sources`)
- Installing VS Code from Microsoft repo
- Installing Docker Engine + compose plugin
- Installing NVM for `efortmeyer` and `eric`
- (Optional) restoring VS Code settings/extensions/profiles via scripts
- (Optional) restoring shell config (.zshrc/.bashrc) and oh-my-zsh install

## What This Repo Does *Not* Manage

- `.env` files and docker-compose files for projects/b monorepo
  - Those live in the project itself; clone the project separately.
- Private SSH keys / tokens
- Browser/Evolution profiles (document/setup manually)

## Bring-up (After Debian Install)

### During Debian install

- Create user: `efortmeyer` (recommended as the installer-created user)
- Enable LUKS encryption on the main SSD

### After first login

```bash
sudo apt update
sudo apt install -y git
git clone https://github.com/ericfortmeyer/incomplete-stack.git
cd incomplete-stack
./setup.sh   # or bash hosts/hiram/init/bootstrap.sh
