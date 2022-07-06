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
#!/bin/bash


set -e

spatialPrint() {
    echo ""
    echo ""
    echo "$1"
	echo "================================"
}

sudo apt-get install build-essential
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo dpkg -i google-chrome-stable_current_amd64.deb
# rm google-chrome-stable_current_amd64.deb

# SSH setup
# ssh-keygen -t rsa -b 4096 -C "dominik.boehler@gmx.com"
# MANUAL: then -> https://docs.github.com/en/github/authenticating-to-github/adding-a-new-ssh-key-to-your-github-account

# dotfiles
 # if [ ! -d "/home/$USER/.dotfiles/" ]; then
git clone --recursive git@github.com:dominikb1888/.dotfiles.git ~/.dotfiles



# TODO: Other way to install mackup
sudo apt-get install snapd
sudo snap install mackup --classic
echo "
[storage]
engine = file_system
path = .dotfiles
" > ~/.mackup.cfg

sudo apt-get install aria2 -y
sudo apt-get install font-manager
#MANUAL: create local mackup config file with path to dotfiles


# fish
sudo apt-get install fish
which fish | sudo tee -a /etc/shells


#install python and pipx
sudo apt-get install python3 python3-venv
curl https://bootstrap.pypa.io/get-pip.py | python3
python3 -m pip install --user pipx
python3 -m pipx ensurepath
# ipython and jupyter-lab
~/.local/bin/pipx install jupyter  --include-deps
~/.local/bin/pipx install jupyterlab
~/.local/bin/pipx install rich-cli

# Check if Anaconda's Miniconda is already installed
if command -v /opt/anaconda3/bin/conda &> /dev/null
then
    echo "Anaconda is already installed, skipping installation"
    echo "To reinstall, delete the Anaconda install directory (/opt/anaconda3 if done by this script) and remove from PATH as well"
else

    spatialPrint "Installing the latest Anaconda Python in /opt/anaconda3"
    latest_anaconda_setup="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
    aria2c --file-allocation=none -c -x 10 -s 10 -o anacondaInstallScript.sh --dir ./extras ${continuum_website}${latest_anaconda_setup}
    sudo mkdir -p /opt/anaconda3 && sudo chmod ugo+w /opt/anaconda3
    bash ./extras/anacondaInstallScript.sh -f -b -p /opt/anaconda3

    spatialPrint "Setting up your anaconda"
    /opt/anaconda3/bin/conda update conda -y
    /opt/anaconda3/bin/conda clean --all -y
    /opt/anaconda3/bin/conda install anaconda -y
    /opt/anaconda3/bin/conda install ipython -y

    /opt/anaconda3/bin/conda install libgcc -y
    /opt/anaconda3/bin/pip install numpy scipy matplotlib scikit-learn scikit-image jupyter notebook pandas h5py cython jupyterlab
    /opt/anaconda3/bin/pip install msgpack pynvim
    /opt/anaconda3/bin/conda install line_profiler -y
    sed -i.bak "/anaconda3/d" ~/.zshrc

    /opt/anaconda3/bin/conda info -a

    spatialPrint "Adding anaconda to path variables"
    {
        echo "# Anaconda Python. Change the \"conda activate base\" to whichever environment you would like to activate by default"
        echo ". /opt/anaconda3/etc/profile.d/conda.sh"
        echo "conda activate base"
    } >> ~/.zshrc

fi # Anaconda Installation end

# echo "*************************** NOTE *******************************"
# echo "If you ever mess up your anaconda installation somehow, do"
# echo "\$ conda remove anaconda matplotlib mkl mkl-service nomkl openblas"
# echo "\$ conda clean --all"
# echo "Do this for each environment as well as your root. Then reinstall all except nomkl"
# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# see how to override pre-installed rust

# Node
sudo apt-get install nodejs npm

# Perl
sudo apt-get install perl
curl -L https://install.perlbrew.pl | bash



# neovim
sudo add-apt-repository ppa:neovim-ppa/unstable 
sudo apt-get install neovim

# Neovim Dependencies
~/.cargo/bin/cargo install tree-sitter-cli
sudo npm install -g neovim



# fzf
sudo apt-get install fzf

# utilities
~/.cargo/bin/cargo install rg
sudo apt install fd-find
sudo apt-get install cmake
# ~/.cargo/bin/cargo install --no-default-features exa

sudo apt-get install gh

# Kitty
sudo apt-get install kitty
sudo update-alternatives --config x-terminal-emulator

sudo apt-get install bat

#starship setup
curl -sS https://starship.rs/install.sh | sh 

chsh -s "$(which fish)" 
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish #add fish plugins

/opt/anaconda3/bin/conda init fish
#install rust jupyter kernel
/opt/anaconda3/bin/conda create --name evcxr
/opt/anaconda3/bin/conda activate evcxr
~/.cargo/bin/cargo install evcxr_repl
/opt/anaconda3/bin/conda install -y -c conda-forge nb_conda_kernel
~/.cargo/bin/cargo install evcxr_jupyter


# lunarvim
bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh)

mackup restore
