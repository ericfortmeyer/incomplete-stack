# Smartcard LUKS Unlock in `initramfs`

This document covers smartcard-based LUKS unlock during local boot in `initramfs` on `samson`, and the planned Debian port on `hiram`.

It does not cover `godel`, which uses a separate `initrd` remote-unlock workflow. `initramfs` and `initrd` are different boot environments, and this smartcard setup is intentionally not being applied to `godel`.

## Host roles

- `samson`: reference system with working smartcard LUKS unlock and login integration
- `hiram`: Debian workstation under active development
- `godel`: headless workstation using `initrd` for remote LUKS unlock

## Summary

The working `initramfs` smartcard unlock setup uses:

- `piv-unlock` in `initramfs-tools/scripts/local-top`
- `pcscd` started with `--disable-polkit`
- `gdm-smartcard-pkcs11-exclusive` instead of `gdm-smartcard-sssd-exclusive` in `/etc/pam.d/gdm-smartcard`

## What works

- LUKS root disk can be unlocked from the smartcard during early boot
- The desktop login screen accepts smartcard authentication
- The same smartcard flow can be used for login after boot

## Key findings

- In this environment, `cryptsetup` must use `--token-only`
- The documented `crypttab` `pkcs11-uri` option does not work in `initramfs` because `systemd` is not running there
- At the GDM login screen, press Enter so PAM can detect the user before smartcard auth completes
- When multiple X.509 certificates exist, PKCS #11 URI selection is required for `systemd-cryptenroll`
- FIDO2 is not simpler here, because `pcscd` is still needed and the `systemd-cryptenroll` `crypttab` flow does not apply in `initramfs`

## Implementation details

### `initramfs` unlock path

The unlock flow is implemented by leveraging `/lib/cryptsetup/functions` to read `crypttab`, then using `piv-unlock` in the early boot path.

### `initramfs` hook

A custom hook copies required binaries and shared libraries into the `initramfs` image for:

- `pcscd`
- `opensc`
- `pkcs11` libraries
- `cryptsetup`

The hook uses `copy_exec` and `copy_file` instead of plain `cp`, because those helpers preserve symlinks and include shared-library dependencies of the source binaries.

## Desktop login integration

To make GDM smartcard login work:

- disable the `sssd`-based smartcard PAM path
- use `gdm-smartcard-pkcs11-exclusive`

This avoids the authentication failure seen with the `sssd`-exclusive configuration.

## Configuration notes

### LUKS unlock

Use `--token-only` with `cryptsetup` for the unlock path.

Do not rely on the `crypttab` `pkcs11-uri` setting in `initramfs`; it assumes `systemd` support that is not present there.

### PAM behavior

GDM smartcard authentication requires an initial Enter keypress so PAM can identify the user.

## Validation status

### Verified on `samson`

- Ubuntu 24.04.4 LTS
- systemd 255
- Smartcard LUKS unlock works
- Login integration works

### Port target

- `hiram` is the next target for reproducing the same setup on Debian

### Out of scope

- `godel` remains on its existing `initrd` remote-unlock design
- no `initramfs` smartcard port is planned for `godel`

## Troubleshooting

- If unlock fails in early boot, confirm `pcscd` and its dependencies are present in the image
- If login fails, check that GDM is using the PKCS #11 PAM path
- If multiple certificates exist on the card, make sure the correct PKCS #11 URI is pinned
- If `crypttab` appears correct but unlock still fails, verify that the setup is using `--token-only`

## Next steps

- Port the working `samson` configuration to `hiram`
- Document the exact `initramfs-tools` hook and package list
- Add notes for integrating the same smartcard identity with:
  - `sudo`
  - `SSH`
  - `gpg`
