## 0.6.0 (2026-02-15)

### Feat

- **godel**: enable autosuggestions and syntax highlighting in zsh

### Fix

- **godel**: use correct name for knob

## 0.5.0 (2026-02-15)

### Feat

- add vscode profiles

## 0.4.0 (2026-02-15)

### Feat

- **godel**: add p10k λ-minimal preset and Nix toggle for richer variant
- **godel**: add homelab learning packages
- **godel**: remove desktop GUI
- **godel**: make BIOS boot by-id, modularize host, and declare user+SSH
- **godel**: introduce initial NixOS host configuration and modular base system

### Fix

- **godel**: use correct dollar sign escaping
- **godel**: import the new p10k module
- **godel**: remove packages missing from nixos
- **godel**: use psysh
- **godel**: use phpstan package
- **godel**: use openresolv instead of resolveconf
- **godel**: remove non-existent plugin knob
- **godel**: let nix manage omz stuff, gosh
- **godel**: remove explicit usage of powerlevel10k theme
- **godel**: add static ip reservation
- **godel**: prevent missing plugin warning
- **godel**: make initrd ssh hostname explicit
- **godel**: add powerlevel10k package
- **godel**: use power level 10k if present
- **godel**: apply zshrc tweaks
- **godel**: use sh in initrd shell environment
- **godel**: use multi.user target
- **godel**: correct module import spelling
- **godel**: add packages module
- **godel**: add shell flair
- **godel**: keep ssh sessions alive
- **godel**: make MOTD appear
- **godel**: correct display and desktop manager configurations
- **godel**: add Gödel-number MOTD + tidy section comments + tg3/PHY ordering
- **godel**: ensure broadcom module is loaded in stage 2
- **godel**: make tg3 work in initrd
- **godel**: use correct nic driver to enable initrd ssh
- **godel**: remove unsupported kernel modules
- **godel**: add nic drivers to initrd
- **godel**: prevent module source clash
- **godel**: remove duplicate initrd enable configuration
- **godel**: enable initrd SSH unlock
- **godel**: switch to uuid and partuuid disk references
- **godel**: add flake.lock to version control system
- **godel**: add authorized key for manna
- **godel**: add hardware configuration to flake
- **godel**: deduplicate module imports, add project root argument
- **godel**: configure system state, include git
- **godel**: enable network manager
- **godel**: make users.nix corrections
- **godel**: correct networking configurations

## 0.3.5 (2026-02-11)

### Fix

- **hiram**: correct vscode ext file name

## 0.3.4 (2026-02-11)

### Fix

- **hiram**: remove dbeaver
- **hiram**: use pruned package list
- **hiram**: remove missing packages
- **hiram**: use php.list, use docker stable

## 0.3.3 (2026-02-11)

### Fix

- **hiram**: use slack jessie, correct keyring perms

## 0.3.2 (2026-02-10)

### Fix

- **hiram**: add missing directory to file iteration

## 0.3.1 (2026-02-10)

### Fix

- **hiram**: correct filename expansion

## 0.3.0 (2026-02-10)

### Feat

- **hiram**: use nvm v0.40.4

## 0.2.0 (2026-02-10)

### Feat

- **hiram**: use node lts

### Fix

- **hiram**: add missing sources files

## 0.1.1 (2026-02-10)

### Fix

- **hiram**: remove missing script

## 0.1.0 (2026-02-02)

### Feat

- **gödel**: add init configuration files
- **hiram**: add bootstrapping scripts
- add settings and assets
- add folder scaffolding and docs
- initial commit
