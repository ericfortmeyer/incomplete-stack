# modules/shell/p10k.nix
{ lib, config, pkgs, ... }:
let
  p10kMinimal = ''
  # --- Minimal λ-themed p10k for servers ---
  # Turn off instant prompt by default (enable later if you want).
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off

  # Single-line prompt; no extra newline.
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Left/Right prompt items: lean but useful.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time time)

  # Context: show user@host with subtle color; useful over SSH/root.
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT}_BACKGROUND=
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT}_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_CONTEXT_SUDO_CONTENT_EXPANSION='%n@%m (sudo)'

  # Directory: retain last 3 segments; concise color.
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=yellow

  # Git: cleanliness + ahead/behind; stay snappy on large repos.
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT='git…'
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=2
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1  # detect dirty even in big repos

  # Exit status: only on error.
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red

  # Command time: show if > 1s; concise format.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=magenta
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT="''${duration}"

  # Time (right side).
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_TIME_FORMAT='%H:%M'

  # λ prompt char (works well in most terminals; change to '>' if needed).
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS='λ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS='λ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=cyan
  '';
  p10kRicher = ''
  # --- Richer λ-themed p10k for dev/FP contexts ---
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=false

  # Left prompt: context, dir, vcs; show dev env signals after dir.
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    context
    dir
    nix_shell
    pyenv
    node_version
    kubecontext
    vcs
  )

  # Right prompt: status/time, plus duration of long commands.
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    status
    command_execution_time
    time
  )

  # Context (SSH/root aware).
  typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE='%n@%m'
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT}_BACKGROUND=
  typeset -g POWERLEVEL9K_CONTEXT_{DEFAULT,ROOT}_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_CONTEXT_SUDO_CONTENT_EXPANSION='%n@%m (sudo)'

  # Directory: keep it readable.
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=yellow

  # Git: show branch, clean/dirty, ahead/behind; keep latency bounded.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=green
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=red
  typeset -g POWERLEVEL9K_VCS_LOADING_TEXT='git…'
  typeset -g POWERLEVEL9K_VCS_MAX_SYNC_LATENCY_SECONDS=2
  typeset -g POWERLEVEL9K_VCS_MAX_INDEX_SIZE_DIRTY=-1

  # Nix shell indicator (shows 'nix' + shell name).
  typeset -g POWERLEVEL9K_NIX_SHELL_FOREGROUND=blue
  typeset -g POWERLEVEL9K_NIX_SHELL_CONTENT_EXPANSION="nix:''${P9K_CONTENT}"
  typeset -g POWERLEVEL9K_NIX_SHELL_PROMPT_SUFFIX=""

  # Python virtualenv (pyenv/venv).
  typeset -g POWERLEVEL9K_PYENV_FOREGROUND=magenta
  typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=false
  typeset -g POWERLEVEL9K_PYENV_SOURCES=(virtualenv anaconda pyenv)

  # Node version (using nvm or system node).
  typeset -g POWERLEVEL9K_NODE_VERSION_FOREGROUND=green
  typeset -g POWERLEVEL9K_NODE_VERSION_PROJECT_ONLY=true

  # Kubernetes (if kubectl present): context/namespace trimmed.
  typeset -g POWERLEVEL9K_KUBECONTEXT_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_KUBECONTEXT_DEFAULT_CONTENT_EXPANSION="k8s:''${P9K_KUBECONTEXT_NAME}/''${P9K_KUBECONTEXT_NAMESPACE}"
  typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|k9s'

  # Exit status: only on error.
  typeset -g POWERLEVEL9K_STATUS_OK=false
  typeset -g POWERLEVEL9K_STATUS_ERROR=true
  typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND=red

  # Command time if >1s.
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=1
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=magenta
  typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FORMAT="''${duration}"

  # Time (right).
  typeset -g POWERLEVEL9K_TIME_FOREGROUND=cyan
  typeset -g POWERLEVEL9K_TIME_FORMAT='%H:%M'

  # λ prompt char.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_VIINS='λ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_VIINS='λ'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND=cyan
  '';
in
{
  options.shell.p10k.variant = lib.mkOption {
    type = lib.types.enum [ "minimal" "richer" ];
    default = "minimal";
    description = "Choose Powerlevel10k prompt variant.";
  };

  config = {
    environment.etc."p10k.zsh".text =
      if config.shell.p10k.variant == "minimal" then p10kMinimal else p10kRicher;

    programs.zsh.promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source /etc/p10k.zsh
    '';
  };
}
