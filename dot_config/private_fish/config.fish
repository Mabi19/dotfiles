set -g fish_greeting
set -gx EDITOR micro
set -gx SHELL (which fish)

if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_autosuggestion_enabled 0
    starship init fish | source
end
