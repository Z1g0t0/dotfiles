# Set up the prompt

#autoload -Uz promptinit
#promptinit
#prompt adam1
#
# 10ms for key sequences
KEYTIMEOUT=1

bindkey -v
bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
#Ctrl-w - delete a full WORD (including colon, dot, comma, quotes...)
my-backward-kill-word () {
    # Add colon, comma, single/double quotes to word chars
    local WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>:,"'"'"
    zle -f kill # Append to the kill ring on subsequent kills.
    zle backward-kill-word
}
zle -N my-backward-kill-word
bindkey '^w' my-backward-kill-word

export TERM=screen-256color
autoload colors && colors

PS1="%B%{$fg[green]%}%n%{$fg[red]%}:%{$fg[yellow]%}<%{$fg[blue]%}%1~%{$fg[yellow]%}>%{$reset_color%} %b"
RPROMPT="%B%{$fg[green]%}%*%b"

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

alias rm='rm -f'
alias cp='cp -i'
alias mv='mv -i'
alias ll='ls -alF --color=tty'
alias la='ls -a --color=tty'
alias l='ls -CF --color=tty'

