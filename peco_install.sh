#!/bin/sh

cd
mkdir -p local/src/
mkdir -p local/bin/

cd local/src
wget https://github.com/peco/peco/releases/download/v0.2.9/peco_linux_amd64.tar.gz
tar -C ~/local -xzf peco_linux_amd64.tar.gz
mv ~/local/peco_linux_amd64/peco ~/local/bin/
chmod 700 ~/local/bin/peco

cd
mkdir .peco
ln -s ~/d/config.json ~/.peco/config.json
