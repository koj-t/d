#zsh-completion
if [ -e /usr/local/share/zsh-completions ]; then
        fpath=(/usr/local/share/zsh-completions $fpath)
fi

autoload -Uz compinit
compinit -u #for git-completion

# 言語設定
export LANG=ja_JP.UTF-8

# エディタvim
export EDITOR=vim

# openで開く
alias op=open

# PCRE 互換の正規表現
# setopt re_match_pcre

# ビープ音消す
setopt nolistbeep

# 日本語ファイル名表示可能
setopt print_eight_bit

# '#' 以降コメント
setopt interactive_comments

# emacsバインド
bindkey -e

# Ctrl + r で履歴
bindkey "^R" history-incremental-search-backward

# Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
bindkey "^[[Z" reverse-menu-complete

# 補完候補省スペース
setopt list_packed

# 補完時に大文字小文字無視
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

### -----------------------------------------------------------------------
### 補完
autoload -U compinit; compinit -C

### 補完方法毎にグループ化
zstyle ':completion:*' format '%B%F{blue}%d%f%b'
zstyle ':completion:*' group-name ''
### 補完侯補をメニューから選択
### select=2: 補完候補を一覧から選択 補完候補が2つ以上なければすぐに補完
zstyle ':completion:*:default' menu select=2
### 補完候補に色付け
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
### 補完候補がなければより曖昧に候補を探す
### m:{a-z}={A-Z}: 小文字を大文字に変えたものでも補完
### r:|[._-]=*: 「.」「_」「-」の前にワイルドカード「*」があるものとして補完
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' recent-dirs-insert both

### 補完候補
### _oldlist 前回の補完結果を再利用する
### _complete: 補完する
### _match: globを展開しないで候補の一覧から補完する
### _history: ヒストリのコマンドも補完候補とする
### _ignored: 補完候補にださないと指定したものも補完候補とする
### _approximate: 似ている補完候補も補完候補とする
### _prefix: カーソル以降を無視してカーソル位置までで補完する
zstyle ':completion:*' completer _complete _ignored

## 補完候補をキャッシュ
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh/cache
### -----------------------------------------------------------------------

setopt complete_in_word
setopt magic_equal_subst

# 補完候補が複数あるときに自動的に一覧表示
setopt auto_menu

# 変数名を補完する
setopt auto_param_keys

# cd可能ディレクトリを探す
# setopt cdable_vars

# 高機能なワイルドカード展開
setopt extended_glob

# ディレクトリ名でcd
setopt auto_cd

# cdの履歴を記録
setopt auto_pushd

# 重複ディレクトリを追加しない
setopt pushd_ignore_dups

# 時刻を残す
setopt extended_history

# タイポを訂正
# setopt correct

# 履歴関連
# ----------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 重複する履歴は無視
setopt hist_ignore_dups

# 履歴を共有
setopt share_history

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

 # ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 複数の zsh を同時に使う時など history ファイルに上書きせず追加する
setopt append_history

# 重複するコマンドが記憶されるとき、古い方を削除する。
setopt hist_ignore_all_dups

# 重複するコマンドが保存されるとき、古い方を削除する。
setopt hist_save_no_dups


#履歴の検索
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey '^p^p' history-beginning-search-backward-end
bindkey '^n^n' history-beginning-search-forward-end

# カーソル左消去
bindkey "^u^u" backward-kill-line
