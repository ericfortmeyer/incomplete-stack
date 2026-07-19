# Why NixOS

**Reproducibility as Documentation**

NixOS provides a cleaner path to reproducible systems compared to imperative bash scripts or manual configuration. The declarative `.nix` files serve double duty: they configure your system *and* document its state. This removes the gap between "what the system is supposed to be" and "what it actually is."

**Immutability Prevents Drift**

The immutable nature of NixOS prevents ad-hoc changes from degrading your declared configuration. Unlike traditional systems where operators can drift away from documented intent, NixOS keeps reality tethered to your `.nix` files—whether through discipline or by design.

**Faster, Safer Updates**

Declarative updates are less error-prone and often faster than imperative ones. You describe the desired state; NixOS handles the transition. The dry-run feature is particularly powerful—you can preview changes before applying them, catching mistakes early.

## Critiques

**Non-FHS Design**

NixOS doesn't follow the Filesystem Hierarchy Standard (FHS), so, configuration files, installed packages, etc., are not where you would expect them to be. That said, distributions are not obligated to follow FHS, and, NixOS does not attempt hybrid compatibility.
