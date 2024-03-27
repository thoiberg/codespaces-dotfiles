#!/bin/bash

# taken from https://bea.stollnitz.com/blog/codespaces-terminal/
create_symlinks() {
    # Get the directory in which this script lives.
    script_dir=$(dirname "$(readlink -f "$0")")

    # Get a list of all files in this directory that start with a dot.
    if [[ -n "$CODESPACES" ]]; then
        files=$(find -maxdepth 1 -type f -name ".*")
    else
        files=$(find -maxdepth 1 -type f -name ".*" | grep -v .gitconfig)
    fi

    # Create a symbolic link to each file in the home directory.
    for file in $files; do
        name=$(basename $file)

        if [ ! -f ~/$name ]; then
            echo "Creating symlink to $name in home directory."
            ln -s $script_dir/$name ~/$name
        fi
    done
}

sudo apt-get update
sudo apt-get install -y powerline fonts-powerline ttf-ancient-fonts fzf less
wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh

### ZSH config
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
git clone https://github.com/mashaal/wild-cherry.git "$ZSH_CUSTOM/themes/wild-cherry" --depth=1
ln -s "$ZSH_CUSTOM/themes/wild-cherry/zsh/wild-cherry.zsh-theme" "$ZSH_CUSTOM/themes/wild-cherry.zsh-theme"

# remove the default zshrc
rm -f ~/.zshrc
create_symlinks

# configure good code
sudo ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
sudo dpkg-reconfigure -f noninteractive tzdata

if command -v npm &> /dev/null
then
    sudo npm install diff-so-fancy --location=global
else
    git clone git@github.com:so-fancy/diff-so-fancy.git ~/diff-so-fancy
    echo "export PATH=$PATH:~/diff-so-fancy" >> ~/.zshrc
    echo "export LC_ALL=C" >> ~/.zshrc
fi
