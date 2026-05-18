# ----------------------------------------------------------------------------------------------------------------------
#  Init
# ----------------------------------------------------------------------------------------------------------------------

fish_add_path "$HOME"/.local/bin
fish_add_path "$HOME"/Dropbox/bin

set -U XDG_CACHE_HOME ~/.cache
set -U XDG_CONFIG_HOME ~/.config
set -U XDG_DATA_HOME ~/.local/share

if not functions -q fundle
    eval (wget -qO- https://git.io/fundle-install)
end

set -g fundle_plugins_dir "$XDG_CONFIG_HOME"/fish/plugins

status --is-interactive; and type -q zoxide; and source (zoxide init fish | psub)
status --is-interactive; and type -q direnv; and source (direnv hook fish | psub)
status --is-login; and type -q fastfetch; and fastfetch

# ----------------------------------------------------------------------------------------------------------------------
#  Settings
# ----------------------------------------------------------------------------------------------------------------------

set fish_greeting ""
set fish_color_valid_path

# ----------------------------------------------------------------------------------------------------------------------
# Bindings
# ----------------------------------------------------------------------------------------------------------------------

bind \eq exit

# ----------------------------------------------------------------------------------------------------------------------
# Colors
# ----------------------------------------------------------------------------------------------------------------------

set nord0 2e3440
set nord1 3b4252
set nord2 434c5e
set nord3 4c566a
set nord4 d8dee9
set nord5 e5e9f0
set nord6 eceff4
set nord7 8fbcbb
set nord8 88c0d0
set nord9 81a1c1
set nord10 5e81ac
set nord11 bf616a
set nord12 d08770
set nord13 ebcb8b
set nord14 a3be8c
set nord15 b48ead

set fish_color_normal $nord4
set fish_color_command $nord9
set fish_color_quote $nord14
set fish_color_redirection $nord9
set fish_color_end $nord6
set fish_color_error $nord11
set fish_color_param $nord4
set fish_color_comment $nord3
set fish_color_match $nord8
set fish_color_search_match $nord8
set fish_color_operator $nord9
set fish_color_escape $nord13
set fish_color_cwd $nord8 --bold
set fish_color_autosuggestion $nord8 --dim
set fish_color_user $nord4 --dim
set fish_color_host $nord9
set fish_color_cancel $nord15
set fish_pager_color_prefix $nord13
set fish_pager_color_completion $nord6
set fish_pager_color_description $nord10
set fish_pager_color_progress $nord12
set fish_pager_color_secondary $nord1

# ----------------------------------------------------------------------------------------------------------------------
# Aliases and/or Functions
# ----------------------------------------------------------------------------------------------------------------------

alias ...='cd $(git rev-parse --show-toplevel)'

function a --wraps=apt --description 'alias a apt'
    apt $argv
end
function A --wraps='sudo apt' --description 'alias A sudo apt'
    sudo apt $argv
end

function b --wraps=bundle --description 'alias b bundle'
    switch $argv[1]
        case "."
            if not set -q arg[1]; and not test -f .envrc
                echo 'use ruby' >.envrc
                sleep 0.1
                direnv allow .

                return
            end
        case i
            bundle install $argv[2..-1]
        case u
            bundle update $argv[2..-1]
        case e
            bundle exec $argv[2..-1]
        case c
            bundle config $argv[2..-1]
        case "*"
            bundle $argv
    end
end

function d --wraps=direnv --description 'alias d direnv'
    direnv $argv
end

function e --wraps=nvim --description 'alias e nvim'
    nvim $argv
end
function E --wraps='sudo nvim' --description 'alias E sudo nvim'
    sudo nvim $argv
end

function g --wraps=git --description 'alias g git'
    git $argv
end

function i --wraps=inkscape --description 'alias i inkscape'
    inkscape $argv
end
function I --wraps=inkview --description 'alias i inkview'
    inkview $argv
end

function j --wraps=journalctl --description 'alias j journalctl'
    journalctl --user -u $argv
end
function J --wraps='sudo journalctl' --description 'alias J sudo journalctl'
    sudo journalctl $argv
end

function l --wraps=lazygit --description 'alias l lazygit'
    lazygit $argv
end

function m --wraps=rake --description 'alias m rake'
    ramake $argv
end
function M --wraps=rake --description 'alias M rake'
    ramake $argv
end

function o --wraps=open --description 'alias o open'
    open $argv
end

function s --wraps='systemctl' --description 'alias s systemctl'
    systemctl --user $argv
end
function S --wraps='sudo systemctl' --description 'alias S sudo systemctl'
    sudo systemctl $argv
end

function r --wraps=rails --description 'alias r rails'
    bundle exec rails $argv
end

function t --wraps=todo.sh --description 'alias todo.sh'
    todo.sh -t $argv
end
function T --wraps=todo.sh --description 'alias todo.sh wtf'
    todo.sh wtf
end

function v --wraps=vi --description 'alias v vi'
    vi $argv
end
function V --wraps='sudo vi' --description 'alias V sudo vi'
    sudo vi $argv
end

function x --wraps='bundle exec' --description 'alias x bundle exec'
    bundle exec $argv
end

# ----------------------------------------------------------------------------------------------------------------------
# Plugins
# ----------------------------------------------------------------------------------------------------------------------

fundle plugin metrofish/metrofish
fundle plugin "PatrickF1/fzf.fish"

fundle init
