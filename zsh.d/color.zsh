export TERM=xterm-256color
autoload -Uz colors; colors
export LSCOLORS=Exfxcxdxbxegedabagacad

# 補完時の色の設定
export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

# ZLS_COLORS？
export ZLS_COLORS=$LS_COLORS

# lsコマンド時、自動で色がつく
export CLICOLOR=true

# プロンプトの設定
# ----------------------------
# Git情報
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz is-at-least

zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*' formats '[%s: %b]'
zstyle ':vcs_info:*' actionformats '[%s: %b|%a]'
zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
zstyle ':vcs_info:bzr:*' use-simple true

zstyle ':vcs_info:git:*' formats '[%s: %b] %c%u'
zstyle ':vcs_info:git:*' actionformats '[%s: %b|%a] %c%u'

if is-at-least 4.3.10; then
  zstyle ':vcs_info:git:*' check-for-changes true
  zstyle ':vcs_info:git:*' stagedstr "+"
  zstyle ':vcs_info:git:*' unstagedstr "-"
  zstyle ':vcs_info:git:*' formats '%c%u [%b]'
  zstyle ':vcs_info:git:*' actionformats '%c%u [%b|%a]'
fi

function _update_vcs_info_msg() {
  psvar=()
  LANG=en_US.UTF-8 vcs_info
  [[ -n "$vcs_info_msg_0_" ]] && psvar[1]="$vcs_info_msg_0_"
}
add-zsh-hook precmd _update_vcs_info_msg

# コマンドを実行するときに右プロンプト消す
setopt transient_rprompt

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

PROMPT="${fg[white]}$([ -n "$TMUX" ] && tmux display -p "#I")""${fg[blue]}$ %1(v|${fg[green]}%C%b%B ${fg[red]}%1v|%B${fg[green]}%~%f%b${fg[white]})${reset_color} [ %* ]
>> "

# プロンプト指定(コマンドの続き)
PROMPT2='[%n]> '

# 右プロンプト
# RPROMPT="%1(v|%B%F{red}%1v%f%F{green}%C%f%b|%B%F{green}%~%f%b$fg[white])"
# RPROMPT="%1(v|%B$fg[red]%1v$fg[green]%C%b|%B$fg[green]%~%f%b$fg[white])"

# SSHプロンプト
PCOLOR=$fg[red]
hn=$(hostname)
[ -n "${REMOTEHOST}${SSH_CONNECTION}" ] &&
  PROMPT="${PCOLOR}${HOST%%.*}${fg[white]}:${PROMPT}"
;

TRAPALRM () { zle reset-prompt }
TMOUT=60
