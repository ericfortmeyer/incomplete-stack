# SSH Access with a PIV Smartcard

This page describes how to authenticate to homelab hosts with the PIV
authentication key on a smartcard instead of a file-based private key.

## Prerequisites

- A PIV card or YubiKey with a certificate and private key in slot 9A
  (PIV Authentication).
- OpenSC installed on the client. On Debian and Ubuntu:

  ```sh
  sudo apt install opensc
  ```

- The `pcscd` service running on the client.

## Client configuration

Add `PKCS11Provider` to each host entry in `~/.ssh/config`:

```sshconfig
Host godel
    HostName godel.example.lan
    PKCS11Provider /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
```

The path above is for Debian and Ubuntu on x86_64. To find the library on
other systems:

```sh
dpkg -L opensc-pkcs11 | grep opensc-pkcs11.so   # Debian/Ubuntu
```

## Exporting the public key

To get the public key from the card in OpenSSH format:

```sh
ssh-keygen -D /usr/lib/x86_64-linux-gnu/opensc-pkcs11.so
```

Copy the output line into the host's `authorized_keys` file in the repo.

## Server configuration

On Gödel, the key lives in:

```
nixos/hosts/godel/authorized_keys
```

Append the PIV public key, commit it, and rebuild the host as described in
the Quick Start.

## Verification

```sh
ssh -v godel
```

Look for these lines in the verbose output:

- `Offering public key` referencing the PKCS#11 provider
- `Server accepts key`

Then confirm you get a shell without a password prompt.

## Troubleshooting

- **Card not detected:** confirm `pcscd` is running and the reader shows up
  in `pkcs15-tool --list-certificates`.
- **PIN prompts on every connection:** this is expected unless you run an
  agent that caches the PIN.
- **Lockout risk:** keep at least one other working key in `authorized_keys`
  until smartcard login has been confirmed on every host, and make sure you
  can still reach initrd unlock if the card is unavailable.
