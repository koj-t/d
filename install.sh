#!/bin/sh
# このディレクトリ名は ~/dにすること
ln -s ~/d/.vimrc ~/.vimrc
ln -s ~/d/.zshrc ~/.zshrc
ln -s ~/d/.tmux.conf ~/.tmux.conf
ln -s ~/d/.global_gitignore ~/.global_gitignore
ln -s ~/d/.gitconfig ~/.gitconfig

if [ ! -e ~/.zsh ]; then
    mkdir ~/.zsh
    git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/zsh-syntax-highlighting
fi

sh ~/d/peco_install.sh
