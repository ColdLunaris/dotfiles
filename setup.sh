#!/bin/bash
if [[ $EUID != 0 ]]; then
    echo "Run this script as root"
    exit 1
fi

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PACKAGES=(feh xautolock xss-lock git wget zsh vim i3status awk compton hsetroot xsel rofi xsettingsd lxappearance scrot viewnior i3lock dunst)

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
 
	# Find the right package manager. Exit if failed
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

        # Install packages
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

echo -e "Install polybar manually"

# Link config files
echo -e "Hardlinking files for easy updating to git..."
echo -e "DO NOT REMOVE THIS DIRECTORY WHEN DONE. IT WILL DELETE FILES!!!"
mkdir -p /home/$SUDO_USER/.config/{i3,i3status,polybar}
mkdir -p /home/$SUDO_USER/.fonts
ln $DIR/{.*rc,.Xresources} /home/$SUDO_USER/
ln $DIR/.config/i3/* /home/$SUDO_USER/.config/i3/
ln $DIR/.config/i3status/* /home/$SUDO_USER/.config/i3status/
ln $DIR/.config/polybar/* /home/$SUDO_USER/.config/polybar/
ln $DIR/.config/lock.sh /home/$SUDO_USER/.config/
ln $DIR/.fonts/* /home/$SUDO_USER/.fonts/

#Change owner of files since root copied them
echo -e "Changing owners of copied files from root to $SUDO_USER"
chown $SUDO_USER:$SUDO_USER /home/$SUDO_USER/{.*rc,.Xresources}
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/i3*
chown -R $SUDO_USER:$SUDO_USER /home/$SUDO_USER/.config/polybar

# Make custom scripts executable
echo -e "Making scripts executable..."
find /home/$SUDO_USER/.config/i3status -type f -name "*.sh" -exec chmod +x {} + #&>/dev/null
find /home/$SUDO_USER/.config/polybar -type f -name "*.sh" -exec chmod +x {} + #&>/dev/null
find /home/$SUDO_USER/.config -type f -name "lock.sh" -exec chmod +x {} + #&>/dev/null

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
