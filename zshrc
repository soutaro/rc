source ~/.zsh_env

autoload -U compinit
compinit

autoload -Uz vcs_info
#zstyle ':vcs_info:*' formats '(%s)-[%S@%b]'
zstyle ':vcs_info:*' formats '%r(%s)-[%S]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
RPROMPT="%1(v|%F{green}%1v%f|)"

PROMPT="%B%{[31m%}%n@%m%%%{[m%}%b "
RPROMPT="%1(v|%F{green}%1v%f|%{[31m%}[%~]%{[m%})"
SPROMPT="correct: %R -> %r ? "

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt hist_ignore_dups
setopt share_history
setopt nohashall

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

#rvm
if [[ -s /Users/soutaro/.rvm/scripts/rvm ]] ; then source /Users/soutaro/.rvm/scripts/rvm ; fi

