# Taglio PIV Badge Setup

If using a Taglio PIV badge, the Linux tools tried so far could not write to
the card. The vendor's proprietary management tool has been used instead.
See the untested section below for `pkcs15-init`.

After writing your cert with CN matching your login name:

1. Run `systemd-cryptenroll --pkcs11-token-uri auto`
2. Verify single cert on card: `pkcs11-tool --list-objects`

## Provisioning with pkcs15-init (untested)

It is not known whether OpenSC's `pkcs15-init` can write a certificate and
private key to this badge. It has not been tested. The vendor tool described
above is the known-good path.

If you test it, record the exact command, the OpenSC version, and the full
output, whether it succeeds or fails. Do not mark this method as working
until a certificate written with it passes `pkcs11-tool --list-objects` and
an SSH login succeeds with the resulting key.
