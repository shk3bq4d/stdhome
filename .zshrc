# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export GOPATH=~/go
path=($path $GOPATH/bin) # otherwise kubectl doesn't work per SSH (likely have PATH exported from parent urxvt window when not using SSH)

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes

ZSH_THEME="mr"
#set -x
test -f ~/.oh-my-zsh/custom/themes/${ZSH_THEME}.zsh-theme || ZSH_THEME="agnoster"
#set +x
#ZSH_THEME="agnoster"
#echo theme is $ZSH_THEME

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"
HIST_STAMPS="dd.mm.yyyy"

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]='fg=blue,underline,italic'
# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-autosuggestions history-substring-search vi-mode-mr z kubectl ansible zsh-syntax-highlighting) # zsh-syntax-highlighting must be the last
if [[ $HOSTNAMEF == $WORK_PC1F ]]; then
    plugins=(git-auto-fetch $plugins)
    GIT_AUTO_FETCH_INTERVAL=1200
fi
# minikube # minikube init seams slowish
# helm # doesn't complet
typeset -U path
test -n ${SSH_CLIENT:-} && path=(~/bin $path) # otherwise kubectl doesn't work per SSH (likely have PATH exported from parent urxvt window when not using SSH)
if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
    source $ZSH/oh-my-zsh.sh
else
    echo -e "oh-my-zsh absent\ninstall via sh -c \"\$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)\"\nor visit https://github.com/robbyrussell/oh-my-zsh"
fi
setopt null_glob
for f in \
    ~/.zsh-aliases/* \
    ; do
        [[ -f $f ]] && source $f
done
unsetopt null_glob


# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
#source ~/bin/dot.bashfunctions
source ~/.bashrc
for c in \
    aliashelp \
    ant \
    az \
    castnow \
    command \
    doc \
    kubectl \
    fahrplan \
    locate \
    minikube \
    ps-mr.sh \
    screen \
    setxkbmap \
    ssh \
    sshfs \
    vagrant \
    viw \
    watch \
    which \
    ; do
    eval "alias $c='nocorrect $c'"
done
alias ah='nocorrect aliashelp'
alias cp='nocorrect cp -ip'
alias mv='nocorrect mv -i'
alias ncal='ncal -M'
"git-clone.py"() {
    command git-clone.py $@ &&
    cd $(cat ~/.tmp/git-clone.py.txt)
}
"kubectl-get-yaml.py"() {
    local mrcolorsafe
    mrcolorsafe=0
    test -t 1 && mrcolorsafe=1
    MRCOLORSAFE=$mrcolorsafe command kubectl-get-yaml.py "$@" | less
}
complete_function() {
    local f=$1; shift
    compdef -e "words[1]=( ${${(qq)@}} ); (( CURRENT += $# - 1 )); _normal" $f
  }
complete_function kubectl-get-yaml.py       kubectl get
complete_function kubectl-watch-pods.sh     kubectl get pods
complete_function kubectl-watch-events.sh   kubectl get events
complete_function kubectl-debug-tail-pod.sh kubectl get pods
compdef "ssh-no-host-checking"=ssh
compdef ssh-vagrant=ssh
#complete_function ssh-no-host-checking ssh

case $UNAME in \
freebsd)
    alias grep='nocorrect grep --line-buffered -a --color=auto'
    alias -g X="|tr '\n' '\0' | xargs -0 -o"
    alias -g XX='|xargs -o'
    alias -g 'X@'='|xargs -o -I@'
    alias -g X1='|xargs -o -n 1'
    alias -g 'X@1'='|xargs -n 1 |xargs -o -I@'
    alias -g 'X1@'='|xargs -n 1 |xargs -o -I@'
    ;;
*)
    alias grep='nocorrect grep --line-buffered -a --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
    alias -g X="| xargs --open-tty --verbose --no-run-if-empty -d '\n'"
    alias -g XX='|xargs --open-tty --verbose --no-run-if-empty'
    alias -g 'X@'='|xargs --open-tty --verbose --no-run-if-empty -I@'
    alias -g X1='|xargs --open-tty --verbose --no-run-if-empty -n 1'
    alias -g 'X@1'='|xargs -n 1 |xargs --open-tty --verbose --no-run-if-empty -I@'
    alias -g 'X1@'='|xargs -n 1 |xargs --open-tty --verbose --no-run-if-empty -I@'
    ;;
esac
alias -g XV="|xargs bash -c '</dev/tty vim \$@' ignoreme"
alias -g XC="|xclip-tee.sh"
alias git='nocorrect git'

alias -g LA='"$(last)"'
alias -g LAS='"$(last)"'
alias -g LAST='"$(last)"'

alias -g L='2>&1|less --raw-control-chars --quit-if-one-screen --ignore-case --status-column --no-init'
alias -g L1='2>/dev/null|L'
alias -g L2='2>&1 >/dev/null|L'

alias -g H='2>&1|head'
alias -g H1='2>/dev/null|H'
alias -g H2='2>&1 >/dev/null|H'

alias -g T='2>&1|tail'
alias -g T1='2>/dev/null|T'
alias -g T2='2>&1 >/dev/null|T'

alias -g LAST1='"$(last 1)"'
alias -g LAST2='"$(last 2)"'
alias -g LAST3='"$(last 3)"'
alias -g LAST4='"$(last 4)"'
alias -g LAST5='"$(last 5)"'

alias -g OY='-o yaml'

alias -g C='2>&1|cat'
alias -g C1='2>/dev/null|C'
alias -g C2='2>&1 >/dev/null|C'

alias -g G='2>&1|grep --line-buffered --color=auto -aE'
alias -g G1='2>/dev/null|G'
alias -g G2='2>&1 >/dev/null|G'

alias -g GI='2>&1|grep --line-buffered --color=auto -iaE'
alias -g GI1='2>/dev/null|GI'
alias -g GI2='2>&1 >/dev/null|GI'

alias -g V='2>&1|vim -R -'
alias -g V1='2>/dev/null|V'
alias -g V2='2>&1 >/dev/null|V'

alias -g N='&>/dev/null'
alias -g N1='>/dev/null'
alias -g N2='2>/dev/null'

alias -g NH='&>/dev/null &'


alias -g P1='|awk "{ print \$1 }"'
alias -g P2='|awk "{ print \$2 }"'
alias -g P3='|awk "{ print \$3 }"'
alias -g P4='|awk "{ print \$4 }"'
alias -g P5='|awk "{ print \$5 }"'
alias -g P6='|awk "{ print \$6 }"'
alias -g P7='|awk "{ print \$7 }"'
alias -g P8='|awk "{ print \$8 }"'
alias -g P9='|awk "{ print \$9 }"'

alias -g P12='|awk "{ print \$1 \" \" \$2 }"'
alias -g P13='|awk "{ print \$1 \" \" \$3 }"'
alias -g P23='|awk "{ print \$2 \" \" \$3 }"'

alias -g P21='|awk "{ print \$2 \" \" \$1 }"'
alias -g P31='|awk "{ print \$3 \" \" \$1 }"'
alias -g P32='|awk "{ print \$3 \" \" \$2 }"'

alias findf='find . -type f'
alias findd='find . -type d'

# https://github.com/robbyrussell/oh-my-zsh/pull/3434/files
#AGNOSTER_STATUS_BG=yellow
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=11'

command_not_found_handler() {
    echo "mr command_not_found_handler 0:$0 \$@: $@"
    return 1
}
function now_millis() {
    case $UNAME in \
    freebsd)
        echo "$(($(date +%s)*1000))"
        ;;
    *)
        echo "$(($(date +%s%N)/1000000))"
        ;;
    esac
}
function preexec() {
    export MR_PREV_COMMAND="$MR_RUNNING_COMMAND"
    export MR_RUNNING_COMMAND="$1"
    #export MR_RUNNING="1"
    export timer=$(now_millis)
    export endtime=""
    echo -ne "\033]0;\u231b $1 - $USER@$HOSTNAMEF\007"
    #echo -e "\u231b" # zsh: character not in range, preexec:6: character not in range: apt install locales-all
}

#setopt promptsubst #
setopt prompt_subst
DISABLE_AUTO_TITLE="true"
function precmd() {
    local MR_LAST=$?
    if false; then
        if [ $timer ]; then
            now=$(now_millis)
            elapsed=$(($now-$timer))

            export RPROMPT="%F{cyan}${elapsed}ms %{$reset_color%}"
            unset timer
        fi
    else
        p=""
        [[ -n ${VIMRUNTIME:-} ]] && p="${p}%F{red}:SH %{$reset_color%}"
        if [ $timer ]; then
            now=$(now_millis)
            elapsed=$(($now-$timer))
            endtime=$(date +'%_H:%M:%S') # it seems that the %* ZSH gets reevaluated when browsing history
            p2=""
            # days
            (( $elapsed >= 86400000 ))                        && p2="${p2}$(($elapsed / 86400000))d"
            # hours
            (( $elapsed >= 3600000 ))                         && p2="${p2}$(($elapsed % 86400000 / 3600000))h"
            # minutes
            (( $elapsed >= 60000    && $elapsed >= 3600000 )) && p2="$(printf "%s%-.02d'" "${p2}" $(($elapsed % 3600000 / 60000 )))"
            (( $elapsed >= 60000    && $elapsed <  3600000 )) && p2="${p2}$(($elapsed % 3600000 / 60000))'"
            # seconds
            if (( $elapsed >= 1000 && $elapsed < 86400000 )); then
                (( $elapsed >= 60000)) \
                    && p2="$(printf "%s%.02d\"" "${p2}" $(($elapsed % 60000 / 1000)))" \
                    || p2="${p2} $(($elapsed / 1000))\""
            fi
            # milliseconds
            (( $elapsed >= 1000     && $elapsed < 60000    )) && p2="$(printf "%s%-.03d" "${p2}" $(($elapsed % 1000)))"
            (( $elapsed <  1000                            )) && p2="${p2} $(($elapsed))ms"
            p="${p}%F{blue}$endtime %F{cyan}${p2}%{$reset_color%}"
            #export RPROMPT="\$(reset_rprompt)%F{cyan}${p} %{$reset_color%}"
            unset timer
            unset endtime
        fi
        export RPROMPT="${p}"
    fi

    local cmd="$MR_RUNNING_COMMAND"
    case "$cmd" in \
        "")
            #return
            ;;
        *\033]0*)
            # The command is trying to set the title bar as well;
            # this is most likely the execution of $PROMPT_COMMAND.
            # In any case nested escapes confuse the terminal, so don't
            # output them.
            #return
            ;;
        mr_prompt)
            ;;
        *)
            #[[ $MR_RUNNING == "1" ]] && return
            ;;
    esac

#            echo "MR_LAST is $MR_LAST"
    echo -ne "\033]0;"
    echo -ne "$MR_URXVT_TITLE"
    case "$cmd" in
        mr_prompt)
            if [[ $MR_LAST -eq 0 ]]; then
                echo -ne '\u2713 '
            else
                echo -ne '\u2718 '
            fi
            ;;
        source*SSHOME*sshrc)
            ;;
        "")
            ;;
        *)
            if [[ $MR_LAST -eq 0 ]]; then
                echo -ne '\u2713 '
            else
                echo -ne '\u2718 '
            fi
            #echo -ne '\u2608 '
            ;;
    esac
    if [[ -n "$MR_TERM" ]]; then
        echo -ne "$MR_TERM"
    elif [[ -n "$SSH_CLIENT" ]]; then
        echo -ne "ssh"
    else
        echo -ne "$TERM"
    fi
    echo -ne " - ${USER}@${HOSTNAMEF}:$PWD "
    case "$cmd" in
        mr_prompt)
            #MR_RUNNING=0
            echo -ne "${MR_PREV_COMMAND}"
            ;;
        source*SSHOME*sshrc)
            ;;
        *)
            #[[ $MR_RUNNING == "0" ]] && MR_PREV_COMMAND="$cmd"
            #MR_RUNNING=1
            #MR_LAST_START=$SECONDS
            #[[ -n "${COLUMNS+1}" ]] && export MR_COLUMNS=$COLUMNS
            echo -ne "${cmd}"
            ;;
    esac
    echo -ne "\007"
}
bindkey "^[[A" history-substring-search-up
bindkey "^[[B" history-substring-search-down
bindkey '^r' history-incremental-search-backward
reset_rprompt() {
    echo "MR_REST=$MR_REST, timer is $timer"
    export MR_REST=43243
    unset timer
    export RPROMPT=""
}
setopt no_share_history # https://stackoverflow.com/questions/9502274/last-command-in-same-terminal

#alias ll='ls -lhFa'
test $UNAME = freebsd || unalias ll # defined as a function in .bashrc

if true; then
    # https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/vi-mode
    bindkey -v
    #set -o vi
    bindkey "${terminfo[khome]}" beginning-of-line
    bindkey "${terminfo[kend]}" end-of-line
    bindkey '^a' vi-forward-blank-word # zsh-autosuggestions
    bindkey '^o' autosuggest-accept
    #echo bip
else
    # https://dougblack.io/words/zsh-vi-mode.html
    bindkey -v
    bindkey '^P' up-history
    bindkey '^N' down-history
    bindkey '^?' backward-delete-char
    bindkey '^h' backward-delete-char
    bindkey '^w' backward-kill-word
    function zle-line-init zle-keymap-select {
        VIM_PROMPT="%{$fg_bold[yellow]%} [% NORMAL]%  %{$reset_color%}"
        RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} $EPS1"
        zle reset-prompt
    }
    zle -N zle-line-init
    zle -N zle-keymap-select
    export KEYTIMEOUT=1
    autoload -z edit-command-line
    zle -N edit-command-line
    bindkey "^V" edit-command-line
fi

fpath=(~/.zsh/completion ~/.zsh/completion/*/ $fpath)
autoload -U compinit
compinit
# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2
#source ~/.bash_completion
compdef _path_commands viw catw lessw
f=~/.zsh/completion/std/bash.az.completion
if [[ -f $f ]]; then
    # https://stackoverflow.com/questions/49273395/how-to-enable-command-completion-for-azure-cli-in-zsh
    autoload -U +X bashcompinit && bashcompinit
    source $f
fi
alias z='nocorrect _z 2>&1' # at the end is necessary as it is defined elsewhere
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=25
if [[ -n "${MR_URXVT_CMD:-}" ]]; then
    command ${=MR_URXVT_CMD}
	# && echo success || echo failure
	# sshrc seems to always end with success
fi
