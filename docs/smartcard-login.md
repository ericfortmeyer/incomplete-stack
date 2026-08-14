# `pam_pkcs11` Integration

This document covers smartcard-based login integration using `pam_pkcs11` for GDM.

It is separate from the early-boot LUKS unlock setup, which is handled elsewhere.

## Host scope

- `samson`: working reference system
- `hiram`: target system for the Debian port

## Summary

The working login setup uses:

- `pam_pkcs11` for smartcard authentication
- `gdm-smartcard-pkcs11-exclusive` instead of `gdm-smartcard-sssd-exclusive`
- a smartcard with the correct X.509 certificate and PKCS #11 identity mapping

## What works

- Smartcard login at the GDM screen
- Login after boot with the same card used for unlock
- User detection by PAM after pressing Enter once at the login screen

## Key finding

GDM does not immediately detect the user from the smartcard alone. Press Enter first so PAM can identify the account before the smartcard authentication step completes.

## Configuration

### PAM

Replace the `sssd` smartcard PAM path with the PKCS #11 path:

```text
gdm-smartcard-sssd-exclusive
→ gdm-smartcard-pkcs11-exclusive
```
