#!/bin/bash

# Install yay if not installed
if ! command -v yay &> /dev/null
then
    echo "Installing yay, the AUR helper..."
    sudo pacman -S --needed git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    echo "yay has been successfully installed."
fi

# Install necessary packages using yay (without sudo)
yay -S google-chrome visual-studio-code-bin mysql

# Check Google Chrome version
if command -v google-chrome &> /dev/null
then
    google-chrome --version && echo "Google Chrome has been successfully installed."
else
    echo "Failed to install Google Chrome."
fi

# Check Visual Studio Code version
if command -v code &> /dev/null
then
    code --version && echo "Visual Studio Code has been successfully installed."
else
    echo "Failed to install Visual Studio Code."
fi

# Install asdf (skip if already installed)
if [ ! -d "$HOME/.asdf" ]; then
    echo "Installing asdf, the version management tool..."
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.10.0
    echo ". $HOME/.asdf/asdf.sh" >> ~/.bashrc
    echo ". $HOME/.asdf/completions/asdf.bash" >> ~/.bashrc
    source ~/.bashrc
    echo "asdf has been successfully installed."
    exec $SHELL
fi

# Install Java with asdf
asdf plugin add java || true
asdf install java temurin-17.0.1+12
asdf global java temurin-17.0.1+12
java -version && echo "Java has been successfully installed." || echo "Failed to install Java."

# Install Kotlin with asdf
asdf plugin add kotlin || true
asdf install kotlin 1.9.22
asdf global kotlin 1.9.22
kotlin -version && echo "Kotlin has been successfully installed." || echo "Failed to install Kotlin."

# Install Node.js with asdf
asdf plugin add nodejs || true
bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
asdf install nodejs latest
asdf global nodejs latest
node --version && echo "Node.js has been successfully installed." || echo "Failed to install Node.js."

# Install Vue.js globally
npm install -g @vue/cli
vue --version && echo "Vue.js has been successfully installed." || echo "Failed to install Vue.js."

# Install Bun
curl -fsSL https://bun.sh/install | bash
bun --version && echo "Bun has been successfully installed." || echo "Failed to install Bun."

# Install Gauge
yay -S gauge-bin
gauge --version && echo "Gauge has been successfully installed." || echo "Failed to install Gauge."

# MySQL setup (needed for initial setup)
sudo systemctl start mysqld
sudo systemctl enable mysqld
sudo mysql_secure_installation
mysql --version && echo "MySQL has been successfully installed." || echo "Failed to install MySQL."

echo "Installation process completed."

