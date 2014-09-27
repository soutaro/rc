source ~/.zsh_env

fpath=(`brew --prefix`/share/zsh/site-functions `brew --prefix`/share/zsh/functions)
autoload -Uz compinit
compinit

autoload -Uz vcs_info
zstyle ':vcs_info:*' formats '%r-[%S@%b]'
zstyle ':vcs_info:*' actionformats '(%s)-[%b|%a]'
precmd () {
    psvar=()
    LANG=en_US.UTF-8 vcs_info
    [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
    print -Pn "\e]2;%~\a"
}
RPROMPT="%1(v|%F{green}%1v%f|)"

PROMPT="%B%{[31m%}%n@%m%%%{[m%}%b "
RPROMPT="%1(v|%F{green}%1v%f|%{[31m%}[%~]%{[m%})"
SPROMPT="correct: %R -> %r ? "

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt hist_ignore_dups
setopt share_history
setopt nohashall
setopt auto_pushd

bindkey -e

alias ls='ls -F -G'
alias ocaml='rlwrap ocaml'
alias tower='open -a Tower'

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

# added by travis gem
[ -f /Users/soutaro/.travis/travis.sh ] && source /Users/soutaro/.travis/travis.sh

eval "$(rbenv init -)"

rehash
