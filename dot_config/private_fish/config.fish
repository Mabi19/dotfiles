set -g fish_greeting
set -gx EDITOR micro
set -gx SHELL (which fish)

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_autosuggestion_enabled 0
    starship init fish | source
end

# pnpm
set -gx PNPM_HOME "/home/mabi/.local/share/pnpm"
if not string match -q -- $PNPM_HOME/bin $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
