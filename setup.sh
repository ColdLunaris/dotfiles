#!/bin/bash
if [[ $EUID != 0 ]]; then
    echo "Run this script as root"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PACKAGES=(git wget zsh vim i3 i3status awk compton hsetroot xsel rofi xsettingsd lxappearance scrot viewnior i3lock dunst)

package_exists() {
    command -v "$1" >/dev/null 2>&1
    if [[ $? -ne 0 ]]; then
        echo "$1 is not installed"
    else
        echo "$1 is installed"
        PACKAGES=(${PACKAGES[@]/$1})
    fi
}

# Check if packages are installed
echo -e "Checking for required packages..."
for package in ${PACKAGES[@]}; do
    package_exists "$package"
done

# Install packages if they are missing
if [[ ${#PACKAGES[@]} -eq 0 ]]; then
    echo -e "All required packages are present..."
else
    read -p "You are missing ${#PACKAGES[@]} packages. Would you like to install them? [y/N] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
	echo -e "\nInstalling packages..."

        if [[ ! -z $(which dnf) ]]; then
            PM='dnf'
        elif [[ ! -z $(which apt) ]]; then
            PM='apt'
	elif [[ ! -z $(which pacman) ]]; then
	    PM='pacman'
        else
	    echo -e "No compatible package manager was found. Exiting..."
	    exit 1;
	fi

        if [[ $PM != 'pacman' ]]; then
	    yes | $PM install ${PACKAGES[@]} &>/dev/null
        else
	    yes | $PM -Syu ${PACKAGES[@]} &>/dev/null
	fi

	if [ $? -eq 0 ]; then
	    echo -e "Installation successful. Continuing..."
	else
            echo -e "Cannot install packages. Install them manually"
	    exit 1;
	fi
    else
	echo -e "\nThese packages must be installed for this script to work. Exiting..."
        exit 1
    fi
fi

# Copy config files
echo -e "Copying files..."
cp -r $DIR/. /home/$SUDO_USER/
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/*

echo -e "Making scripts for i3status executable..."
find /home/$SUDO_USER/.config/i3status -type f -name "*.sh" -exec chmod +x {} + #&>/dev/null

# Install Oh-My-Zsh
echo -e "Installing Oh-My-Zsh..."
su $SUDO_USER -c 'sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" &>/dev/null' &>/dev/null

# Install Oh-My-Zsh plugins
echo -e "Installing Oh-My-Zsh plugins..."
su $SUDO_USER -c "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" &>/dev/null
su $SUDO_USER -c "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" &>/dev/null
su $SUDO_USER -c "git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf" &>/dev/null
su $SUDO_USER -c "git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z" &>/dev/null
su $SUDO_USER -c "yes | ~/.fzf/install" &>/dev/null

# Set Zsh as default shell
if [[ "$(awk -F: -v user="$SUDO_USER" '$1 == user {print $NF}' /etc/passwd)" =~ "$(which zsh)" ]]; then
    echo "Zsh is already your default shell"
else
    read -p "You don't have Zsh as your default shell. Would you like to change this? [y/N] " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        chsh --shell $(which zsh) $SUDO_USER
        echo -e "\nShell has been set to Zsh. Open a new terminal for the changes to take effect"
    else
	echo -e "\nKeeping default shell..."
    fi
fi
