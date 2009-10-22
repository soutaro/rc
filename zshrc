source .zsh_env

autoload -U compinit
compinit

PROMPT="%B%{[31m%}%n@%m%%%{[m%}%b "
RPROMPT="%{[31m%}[%~]%{[m%}"
SPROMPT="correct: %R -> %r ? "

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history

bindkey -e

setopt auto_pushd

alias ls='ls -F -G'
alias ocaml='rlwrap ocaml'

emacs() {
    if [ ! -f $1 ]
    then
	touch $1
    fi
    open -a Emacs $1
}