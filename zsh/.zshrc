# Created by newuser for 5.8.1
source $HOME/.config/shell/aliasrc
source $HOME/.config/shell/custom
source $HOME/.config/shell/profile

setopt appendhistory
setopt autocd extendedglob nomatch menucomplete
setopt interactive_comments
zle_highlight=('paste:none')

# beeping is annoying
unsetopt BEEP

# completions
autoload -Uz compinit
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search


# Plugins
source ~/.config/zsh/.p10k.zsh
source ~/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
source ~/.config/zsh/plugins/zsh-autopair/autopair.plugin.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh
source ~/.config/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

[ -f $ZDOTDIR/completion/_fnm ] && fpath+="$ZDOTDIR/completion/"

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# customize prompt
function xtitle () {
    builtin print -n -- "\e]0;$@\a"
}

function precmd () {
    xtitle "$(print -P '%~')"
}

function preexec () {
	xtitle "$(print -P '\[$1\] %~')"
}
