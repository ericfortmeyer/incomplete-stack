{ config, ... }:

{
  # ────────────────────────────────────────────────────────────────────────────
  # Stage‑1 networking & SSH for remote unlock (initrd)
  # - DHCP in stage‑1: explicitly enable udhcpc (required on 23.11+)
  # - Publish hostname during initrd DHCP to allow `ssh root@godel -p 2222`
  # ────────────────────────────────────────────────────────────────────────────
  boot.kernelParams = [
    # ip=<client-ip>::<gateway>:<netmask>:<hostname>:<iface>:<autoconf>:<dns>
    "ip=192.168.4.47::192.168.4.1:255.255.255.0:godel:enp4s0:none:192.168.4.1"
  ];

  # ────────────────────────────────────────────────────────────────────────────
  # Stage‑2: ensure Broadcom PHY module is available after switch to real root
  # ────────────────────────────────────────────────────────────────────────────
  boot.kernelModules = [ "broadcom" ];
}
