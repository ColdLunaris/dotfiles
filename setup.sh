#!/bin/bash
if [ [ $EUID -ne 0 ]] then
    echo "Run this script as root"
    exit 1
fi

DNF_CMD=$(which dnf)
APT_CMD=$(which apt)
PACMAN_CMD=$(which pacman)
PACKAGES=(git wget zsh vim i3status)
declare -a PACKAGES_TO_INSTALL

# Check if packages are installed
echo "Checking for required packages..."
for p in "${PACKAGES[@]}"; do
    if [[ ! command -v "$p" &> /dev/null ]] then
	echo "$p is not installed"
	PACKAGES_TO_INSTALL+=($p)
    else
	echo "$p is installed"
    fi
done

# Install packages if they are missing
if [[ ${PACKAGES_TO_INTSALL[@]} -eq 0 ]] then
    echo "All required packages are present..."
else
    read -p "You are missing ${PACKAGES_TO_INTSALL[@]} packages. Would you like to install them? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] then
	echo "Installing packages..."

        if [[ ! -z $DNF_CMD ]] then
            PM='dnf'
        elif [[ ! -z $APT_CMD ]] then
            PM='apt'
	elif [[ ! -z $PACMAN_CMD ]] then
	    PM='pacman'
        else
	    echo "No compatible package manager was found. Exiting..."
	    exit 1;
	fi

        if [[ $PM != 'pacman' ]] then
	    yes | $PM install ${PACKAGES_TO_INTSALL[@]}
        else
	    yes | $PM -Syu ${PACKAGES_TO_INTSALL[@]}
	fi

	if [ $? -eq 0 ] then
	    echo "Installation successful. Continuing..."	
	else
            echo "Cannot install packages. Install them manually"
	    exit 1;
	fi
    else
	echo "These packages must be installed for this script to work. Exiting..."
        exit 1
    fi
fi

# Copy config files
echo "Copying files..."
cp -r ./* /home/$LOGNAME/ > /dev/null 2>$1
echo "Making scripts for i3status executable..."
find /home/$LOGNAME/.config/i3status -type f -name "*.sh" -exec chmod +x {} + > /dev/null 2>$1


# Install Oh-My-Zsh
echo "Installing Oh-My-Zsh..."
sudo -u $LOGNAME sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" > /dev/null 2>$1

# Install Oh-My-Zsh plugins
echo "Installing Oh-My-Zsh plugins..."
sudo -u $LOGNAME git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting > /dev/null 2>$1
sudo -u $LOGNAME git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions > /dev/null 2>$1
sudo -u $LOGNAME git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf > /dev/null 2>$1
sudo -u $LOGNAME ~/.fzf/install > /dev/null 2>$1

# Set Zsh as default shell
if [[ $(sudo -u $LOGNAME echo $SHELL) = /usr/bin/zsh ]] then
    echo
else
    read -p "You don't have Zsh as your default shell. Would you like to change this? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]] then
        chsh --shell /usr/bin/zsh $LOGNAME
    else
	echo "Keeping default shell..."
    fi
fi
