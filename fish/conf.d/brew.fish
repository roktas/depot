if type -q brew
    eval (brew shellenv)
else if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
else if test -x "$HOME"/.linuxbrew/bin/brew
    eval ("$HOME"/.linuxbrew/bin/brew shellenv)
else if test -x /home/linuxbrew/.linuxbrew/bin/brew
    eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end
