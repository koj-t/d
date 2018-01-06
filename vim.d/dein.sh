cd ~
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > installer.sh
sh ./installer.sh .local/share/dein
rm -f installer.sh

mkdir -p ~/.local/share/dein/toml
ln -snfv ~/d/vim.d/dein.toml ~/.local/share/dein/toml/dein.toml
ln -snfv ~/d/vim.d/dein_lazy.toml ~/.local/share/dein/toml/dein_lazy.toml
