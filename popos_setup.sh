#!/bin/bash
# =========================================================================== #
#                                                                             #
#  popos-setup.sh                                                             #
#                                                                             #
#  Author:  Jake Zimmerman                                                    #
#  Email:   jake@zimmerman.io                                                 #
#                                                                             #
# This is a list of commands to be run on a fresh Pop!_OS installation.       #
# It is not meant to be run as a script.                                      #
# Run these command manually, in case something has changed.                  #
#                                                                             #
# =========================================================================== #


sudo apt-get install build-essential
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# SSH setup
ssh-keygen -t rsa -b 4096 -C "dominik.boehler@gmail.com"
#MANUAL: then -> https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

# dotfiles
git clone --recursive git@github.com:dominikb1888/dotfiles.git ~/.dotfiles

# TODO: Other way to install mackup
sudo apt-get install mackup
sudo apt-get install font-manager
#MANUAL: create local mackup config file with path to dotfiles

mackup restore

# overwrite .bashrc
# overwrite .erofile

# fish
sudo apt-get install fish
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
curl https://raw.githubusercontent.com/oh-my-fish/master/bin/install | fish

#install python and pipx
sudo apt-get install python3
curl https://bootstrap.pypa.io/get-pip.py | python
python3 -m pip install --user pipx
python3 -m pipx ensurepath
# ipython and jupyter-lab
pipx install ipython jupyter-lab
pipx install rich-cli

# install miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh

#install rust jupyter kernel
conda create --name evcxr
conda activate evcxr
cargo install evcxr_repl
conda install -y -c conda-forge nb_conda_kernel
cargo install evcxr_jupyter

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# see how to override pre-installed rust

/.cargo/bin/evcxr_jupyter --install
# Node
sudo apt-get install nodejs npm

# Perl
sudo apt-get install perl
curl -L https://install.perlbrew.pl | bash


# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable 
sudo apt-get install neovim
ln -s ~/.vim ~/.config/nvim

# lunarvim
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)
cargo install tree-sitter-cli
conda install neovim
pipx install pynvim
sudo npm install -g neovim

# fzf
sudo apt-get install fzf
/home/linuxbrew/.linuxbrew/opt/fzf/install --completion --key-bindings --no-update-rc

# utilities
cargo install rg
cargo install fd
sudo apt-get install cmake
cargo install --no-default-features exa

sudo apt-get install gh

# Kitty
sudo apt-get install kitty
sudo update-alternatives --config x-terminal-emulator

sudo apt-get install bat

#starship setup
curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir /data/data/com.termux/files/usr/bin

