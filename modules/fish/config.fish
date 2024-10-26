if status is-interactive
    # Commands to run in interactive sessions can go here
end

# fish_add_path $HOME/.cargo/bin

abbr -a v nvim
abbr -a e emacs
abbr -a g g++
abbr -a m make
abbr -a .. cd ..
abbr -a ... cd ../../
abbr -a c clear
abbr -a ll ls -FGghot
abbr -a la ls -FGghotA
abbr -a h ghc
abbr -a hi ghci
abbr -a f fzf-tmux -p 30%,30%
abbr -a s xbps-query -Rs
abbr -a i sudo xbps-install -Syu
abbr -a se stack run

# fish_add_path ~/.ghcup/bin/
# fish_add_path ~/.ghcup/ghc/9.0.2/bin/
# fish_add_path ~/.ghcup/hls/1.7.0.0/bin/
# fish_add_path ~/.cabal/bin/
fish_add_path ~/.bin/
fish_add_path ~/.local/bin/
fish_add_path ~/.pack/bin/
set EDITOR kak

set LS_COLORS "di=36;40:ln=0"

set EDITOR vi
function fish_greeting
    neofetch
    cal
end

function fish_default_mode_prompt
    echo ""
end

function fish_title
     prompt_pwd
     date "+  Time: %H:%M:%S"
end

zoxide init fish | source

function fish_user_key_bindings
    # Execute this once per mode that emacs bindings should be used in
    fish_default_key_bindings -M insert

    # Then execute the vi-bindings so they take precedence when there's a conflict.
    # Without --no-erase fish_vi_key_bindings will default to
    # resetting all bindings.
    # The argument specifies the initial mode (insert, "default" or visual).
    fish_vi_key_bindings --no-erase insert
end


