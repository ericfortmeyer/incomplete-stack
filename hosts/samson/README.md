# Samson — projects/a Dev Machine (Already Stood Up)

Samson is dedicated to projects/a development work.

- Ubuntu 24.04.3 LTS
- VS Code + Teams
- Node projects (NestJS + React/Vite; sometimes Angular + NestJS)
- Containers are not typically run locally:
  - k8s workflows create EC2 instances; workloads live in the cloud
- Recently upgraded RAM: 8GB -> 24GB

## Status

✅ Fully configured and operational.
✅ No bootstrap/config work required today.

## Why It Exists in This Repo

Samson is included as a host folder for completeness and future convergence:

- Shared dotfiles/scripts might later apply across machines
- Documentation anchor for how projects/a environment is shaped
- Optional future work: export minimal state (extensions list, settings, a few packages)

## Suggested Minimal Future Additions (Optional)

If/when desired:

- `docs/samson/apt-manual.txt` (or package snapshot)
- `shared/dotfiles/vscode_extensions.txt` (Org A-specific if needed)
- Any small convenience scripts (not required)

## Notes

- Keep Samson changes low-touch: stable projects/a environment.
- Prefer not to “over-automate” Samson unless there’s a strong payoff.
