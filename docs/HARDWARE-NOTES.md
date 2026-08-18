# Taglio PIV Badge Setup

If using a Taglio PIV badge, Linux tools cannot write to the card.
Use the vendor's proprietary management tool instead.

After writing your cert with CN matching your login name:

1. Run `systemd-cryptenroll --pkcs11-token-uri auto`
2. Verify single cert on card: `pkcs11-tool --list-objects`
