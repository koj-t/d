autoload -Uz is-at-least
# エイリアス群
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
case ${OSTYPE} in
    darwin*)
        alias ls="ls -F"
        ;;
    linux*)
        alias ls="ls --color=auto --show-control-chars"
        ;;
esac

alias la="ls -a"
alias ll="ls -l"
alias l="ls"
alias lla="ls -la"
alias j=jobs
alias more=less
alias le="less -iMR"
alias zrc="source ~/.zshrc"
alias cdo="cd ~/d"
alias c='cd `find . -type d -maxdepth 5 -a \! -regex ".*/\..*" | peco`'

alias gr="grep --with-filename --line-number --color=always"

# Global alias
alias -g L="| less -R"
alias -g G="| grep --color=auto"
alias -g W="| wc -l"
alias -g P="| peco"
alias -g X="| xargs"
alias -g H="| head"
alias -g T="| tail"

# # git alias
alias ga='git add'
alias gaa='git add -A'
alias gap='git add -p'
alias gc='git commit -m'
alias gca='git commit --amend'
alias go='git checkout'
alias gb='git branch'
alias gs='git status'
alias gp='git push'
alias gpo='git push origin'
alias gpp='gpo GB'
alias gpf='gpo GB --force'
alias gptf='gpt --force'
alias gtt="git log --graph --pretty='format:%C(cyan)[%cd] %C(yellow)%h%Creset %s %Cgreen(%an) %Cred%d' --date=format:'%y-%m-%d %H:%M:%S'"
alias gta='gt --all'
alias gt='gtt -n 10'
alias gw='git show'
alias gwh='gw HEAD'
alias gl='git pull --rebase'
alias gd='git diff'
alias gdc='gd --cached'
alias gds='gd --stat'
alias gdcs='gdc --stat'
alias grh='git reset --hard'
alias grhh='git reset --hard HEAD'
alias grs='git reset --soft'
alias gob='git checkout -b'
alias gbd='git branch -D'
alias gsh='git stash'
alias gshp='git stash pop'
alias -g GB='`git rev-parse --abbrev-ref HEAD`'

alias g='\go'

# other alias
alias zcfg="vim ~/d/zsh.d"
alias vcfg="vim ~/d/vim.d"
alias cfg="vim ~/.vimrc ~/.zshrc"
alias tcfg="vim ~/.tmux.conf"
alias svim="sudoedit"
alias ...='cd ../..'
alias ....='cd ../../..'
alias cd-='cd -'
alias tt='tree'

if [ -e /usr/local/bin/vim ]; then
    alias vim="/usr/local/bin/vim"
fi

function ta (){
    if [ -z $TMUX ]; then
        if tmux has-session &> /dev/null; then
            tmux attach
        else
            tmux
        fi
    fi
}

function print_known_hosts (){
    if [ -f $HOME/.ssh/known_hosts ]; then
        cat $HOME/.ssh/known_hosts | tr ',' ' ' | cut -d' ' -f1
    fi
}
_cache_hosts=($( print_known_hosts ))

if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi
chpwd() { ls -F }

export PATH=$PATH:~/local/bin

# -----------------------------------
# PECO系のファンクション群
# search history
function peco-history-selection() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER="`history -n 1 | eval $tac  | awk '!a[$0]++' | peco --query "$BUFFER"`"
    CURSOR=$#BUFFER
    zle reset-prompt
}

# search current directory
function peco-find() {
    local l=$(\find . -maxdepth 8 -a \! -regex '.*/\..*' | peco)
    BUFFER="${LBUFFER}${l}"
    CURSOR=$#BUFFER
    zle clear-screen
}
function peco-find-all() {
    local l=$(\find . -maxdepth 8 | peco)
    BUFFER="${LBUFFER}${l}"
    CURSOR=$#BUFFER
    zle clear-screen
}

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

function git-hash(){
    FILTERD=$(git log --oneline --branches | peco | awk '{print $1}')
    BUFFER=${BUFFER}${FILTERD}
    CURSOR=$#BUFFER
}

function git-changed-files(){
    FILTERD=$(git status --short | peco | awk '{print $2}')
    BUFFER=${BUFFER}${FILTERD}
    CURSOR=$#BUFFER
}

function git-edit-changed-files(){
    FILTERD=$(git status --short | peco | awk '{print $2}')
    case ${OSTYPE} in
        darwin*)
            echo "$FILTERD" | xargs -o vim
            ;;
        linux*)
            echo "$FILTERD" | xargs bash -c '</dev/tty vim "$@"' ignoreme
            ;;
    esac
}

if which peco > /dev/null 2>&1; then
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
    zle -N git-hash
    bindkey '^gh' git-hash
    zle -N git-changed-files
    bindkey '^gf' git-changed-files
    bindkey -r '^u'
    zle -N peco-find
    zle -N peco-find-all
    bindkey '^uc' peco-find
    bindkey '^ua' peco-find-all
    zle -N peco-cdr
    bindkey '^ud' peco-cdr
    zle -N git-edit-changed-files
    bindkey '^g^v' git-edit-changed-files
    bindkey '^gv' git-edit-changed-files
fi
# -----------------------------------

# ssh時にtmuxのwindow_name変更
function ssh() {
  if [[ -n $(printenv TMUX) ]]; then
    fgc="black"
    bgc="red"
    local window_name=$(tmux display -p '#{window_name}')
    domain=`echo $@[-1] | cut -d. -f1,3`
    farm=`echo $@[-1] | cut -d. -f3`
    tmux rename-window -- "#[bg=${bgc},fg=${fgc}]${domain}#[bg=default]"
    command ssh $@
    tmux rename-window $window_name
  else
    command ssh $@
  fi
}

# sshのagent設定
agent="$HOME/.ssh/agent"
if [ -S "$SSH_AUTH_SOCK" ]; then
    case $SSH_AUTH_SOCK in
    /tmp/*/agent.[0-9]*)
        ln -snf "$SSH_AUTH_SOCK" $agent && export SSH_AUTH_SOCK=$agent
    esac
elif [ -S $agent ]; then
    export SSH_AUTH_SOCK=$agent
else
    # echo "no ssh-agent"
fi

function agt()
{
    sock=$(ls /tmp/*/agent.[0-9]*)
    export SSH_AUTH_SOCK=$sock
}

# Ctrl-Zのトグル
fancy-ctrl-z () {
if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
else
    zle push-input
    zle clear-screen
fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# zshのシンタックス
if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
      source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# pyenv設定
function penv ()
{
    if [ -e ~/.pyenv ]; then
        export PYENV_ROOT="$HOME/.pyenv"
        export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
}

# anyenv設定
function aenv ()
{
    if [ -e ~/.anyenv ]; then
        # anyenv
        export PATH="$HOME/.anyenv/bin:$PATH"
        eval "$(anyenv init -)"
    fi
}
export GOPATH="$HOME/.go"

# nodebrew
export PATH=$HOME/.nodebrew/current/bin:$PATH

# ctags設定
if [ -e /usr/local/bin/ctags  ]; then
    alias ctags="/usr/local/bin/ctags"
fi

function my-awk()
{
    NUM="$1"
    cat - | awk -v num=$NUM '{print $num}'
}
alias -g A="| my-awk"

if [ $SHLVL -eq 1 ] && which tmux > /dev/null 2>&1 ; then
    ta
fi

export PATH="/usr/local/sbin:$PATH"
