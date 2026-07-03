{ config, ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # Headless server mode (no GUI)
  # ─────────────────────────────────────────────────────────────────────────────

  # Just in case (DM abstraction)
  services.displayManager.gdm.enable = false;
}
