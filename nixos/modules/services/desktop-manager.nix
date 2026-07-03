{ config, ... }:

{
  # ─────────────────────────────────────────────────────────────────────────────
  # Headless server mode (no GUI)
  # ─────────────────────────────────────────────────────────────────────────────

  # Just in case (DE abstraction)
  services.desktopManager.gnome.enable = false;
}
