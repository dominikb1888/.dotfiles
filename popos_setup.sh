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
#set -euo pipefail
#exit

# Homebrew on Linux -> https://docs.brew.sh/Homebrew-on-Linux
# installed into `/home/linuxbrew/.linuxbrew`

sudo apt-get install build-essential
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# SSH setup
ssh-keygen -t rsa -b 4096 -C "dominik.boehler@gmail.com"
# then -> https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

# dotfiles
git clone --recursive git@github.com:dominikb1888/dotfiles.git ~/.dotfiles

# rcm
brew install mackup


# overwrite .bashrc
# overwrite .profile

# zsh
brew install fish
echo "$(brew --prefix)/bin/fish" | sudo tee -a /etc/shells
chsh -s "$(brew --prefix)/bin/fish"

# neovim
brew install neovim
ln -s ~/.vim ~/.config/nvim
cd ~/.vim/bundle/LanguageClient-neovim
bash install.sh
cd -

# fzf
brew install fzf
/home/linuxbrew/.linuxbrew/opt/fzf/install --completion --key-bindings --no-update-rc

# utilities
brew install rg
brew install fd
brew install gh

