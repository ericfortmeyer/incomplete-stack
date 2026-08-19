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

## Required Packages

- `opensc`
- `opensc-pkcs11`
- `pcscd`
- `libpam-pkcs11`

## What works

- Smartcard login at the GDM screen
- Login after boot with the same card used for unlock
- User detection by PAM after pressing Enter once at the login screen

## Key finding

GDM does not immediately detect the user from the smartcard alone. Press Enter first so PAM can identify the account before the smartcard authentication step completes.

## Certificate-to-Login Mapping

pam_pkcs11 supports multiple approaches to map certificates to system logins:

- **CN Matching** (recommended if you control cert generation): Certificate CN = login name
- **Subject Mapping** (flexible): Manual mapping file for arbitrary cert subjects
- **Other methods**: See pam_pkcs11 documentation for additional mappers

---

## CN Matching Approach

This guide uses CN matching with `cn, null, getpwent` configuration.

### Requirements

- X.509 PIV Authentication certificate installed on smartcard
- Certificate CN (Common Name) must match your Linux login name
  - Example: If your login is `jdoe`, cert CN must be `jdoe`
  - Verify: `openssl x509 -in cert.pem -noout -subject`

### Benefits

- No manual mapping files to maintain
- Leverages built-in system tools (getpwent)

## Configuration

### Select Smartcard Authentication Type

Use `update-alternatives` to choose the PKCS#11 backend:

```bash
sudo update-alternatives --config gdm-smartcard
```

Select option **1** for `gdm-smartcard-pkcs11-exclusive`.

### Configure Smartcard Removal Action

Use `gdm-config` to set the removal behavior:

```bash
sudo gdm-config smartcard --enable --removal-action=lock-screen
```

### Verify Configuration

Confirm the settings are applied:

```bash
sudo gdm-config show
```

Expected output:

```zsh
Smart Card authentication: Required
Smart Card removal action: lock-screen
```

---

## Troubleshooting: Direct dconf-defaults Configuration

If `gdm-config` does not apply your smartcard settings to the GDM login screen, the greeter configuration file must be edited directly.

### Why Standard Tools Fail

- `gdm-config`, `gsettings`, and `dconf` modify the **calling user's** dconf database
- The GDM greeter runs under a separate unprivileged user (`debian-gdm`) with its own isolated dconf database
- These standard tools cannot modify the greeter's configuration

### Fallback: Direct File Edit

Edit `/etc/gdm3/greeter.dconf-defaults` as root:

```bash
sudo vim /etc/gdm3/greeter.dconf-defaults
```

Add or uncomment:

```ini
[org/gnome/login-screen]
enable-smartcard-authentication=true
```

Then reload the GDM configuration:

```bash
vim dpkg-reconfigure gdm3
```

Store this configuration file in version control at:

```
hosts/hiram/etc/gdm3/greeter.dconf-defaults
```

---

## Setup

### Copy PAM Configuration Files

Copy the PAM service files from your project to the system:

```bash
sudo cp <project-root>/shared/pam.d/* /etc/pam.d/
```

This installs PAM configuration files for multiple services, each with variants for smartcard and default authentication.

### Configure Update-Alternatives for Each Service

Set up `update-alternatives` to manage authentication type selection across all services:

```bash
# GDM (already shown above, but included for completeness)
sudo update-alternatives --install /etc/pam.d/gdm-smartcard gdm-smartcard \
  /etc/pam.d/gdm-smartcard-pkcs11-exclusive 30

# Sudo
sudo update-alternatives --install /etc/pam.d/sudo sudo \
  /etc/pam.d/sudo-smartcard-exclusive 40
sudo update-alternatives --install /etc/pam.d/sudo sudo \
  /etc/pam.d/sudo-default 30

# Login
sudo update-alternatives --install /etc/pam.d/login login \
  /etc/pam.d/login-default 30
sudo update-alternatives --install /etc/pam.d/login login \
  /etc/pam.d/login-smartcard-exclusive 40
```

To switch authentication types for any service:

```bash
sudo update-alternatives --config sudo
sudo update-alternatives --config login
```

> Note: See [Hardware-Specific Setup](./HARDWARE-NOTES.md)
