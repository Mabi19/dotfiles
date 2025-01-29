set -g fish_greeting
set -g EDITOR micro

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_autosuggestion_enabled 0
    starship init fish | source
end
