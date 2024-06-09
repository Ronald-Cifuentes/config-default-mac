#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install a Hyper plugin if not already installed
install_hyper_plugin() {
    if ! grep -q "\"$1\"" ~/.hyper.js; then
        echo "Installing Hyper plugin: $1"
        npx hyper i "$1"
    else
        echo "Hyper plugin $1 is already installed."
    fi
}

# Function to add a Hyper plugin to the configuration file if not already added
add_hyper_plugin_to_config() {
    if ! grep -q "\"$1\"" ~/.hyper.js; then
        echo "Adding Hyper plugin $1 to configuration"
        sed -i '' "s/plugins: \[/plugins: \[\n    \"$1\",/" ~/.hyper.js
    else
        echo "Hyper plugin $1 already in configuration."
    fi
}

# Install Git
if ! command_exists git; then
    echo "Installing Git..."
    brew install git
else
    echo "Git is already installed."
fi

# Install NVM if not installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "Installing NVM..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
else
    echo "NVM is already installed."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
fi

# Install the latest version of Node.js
echo "Installing the latest version of Node.js..."
nvm install node
nvm use node
nvm alias default node

# Validate Node.js installation
if command_exists node; then
    echo "Node.js installed successfully. Version: $(node -v)"
else
    echo "Node.js installation failed."
fi

# Validate NPM installation
if command_exists npm; then
    echo "NPM installed successfully. Version: $(npm -v)"
else
    echo "NPM installation failed."
fi

# Install Homebrew if not installed
if ! command_exists brew; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo "Homebrew is already installed. Updating..."
    eval "$(/opt/homebrew/bin/brew shellenv)"
    brew update
fi

# Source Homebrew
if [ -f /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -f /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Install Hyper
if ! command_exists hyper; then
    echo "Installing Hyper terminal..."
    brew install --cask hyper
else
    echo "Hyper terminal is already installed."
fi

# Ensure Hyper plugins array is present in the configuration file
if ! grep -q "plugins: \[" ~/.hyper.js; then
    sed -i '' "s/module.exports = {/module.exports = {\n  plugins: [],/" ~/.hyper.js
fi

# Install and configure Hyper plugins
HYPER_PLUGINS=("hypercwd" "hyper-search" "hyper-pane" "hyperpower")
for plugin in "${HYPER_PLUGINS[@]}"; do
    install_hyper_plugin "$plugin"
    add_hyper_plugin_to_config "$plugin"
done

# Install Visual Studio Code
if ! command_exists code; then
    echo "Installing Visual Studio Code..."
    brew install --cask visual-studio-code
    echo "Setting up Visual Studio Code command..."
    export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
    code --install-extension ms-vscode.cpptools
else
    echo "Visual Studio Code is already installed."
fi

# Install ChatGPT
CHATGPT_VERSION="v1.1.0"
CHATGPT_URL="https://github.com/lencx/ChatGPT/releases/download/$CHATGPT_VERSION/ChatGPT_$CHATGPT_VERSION_mac.dmg"
CHATGPT_APP_PATH="/Applications/ChatGPT.app"

if [ ! -d "$CHATGPT_APP_PATH" ]; then
    echo "Installing ChatGPT..."
    curl -L $CHATGPT_URL -o /tmp/ChatGPT.dmg
    hdiutil attach /tmp/ChatGPT.dmg -nobrowse
    cp -r /Volumes/ChatGPT/ChatGPT.app /Applications/
    hdiutil detach /Volumes/ChatGPT
    rm /tmp/ChatGPT.dmg
else
    echo "ChatGPT is already installed."
fi

# Install Anydesk
if ! command_exists anydesk; then
    echo "Installing Anydesk..."
    brew install --cask anydesk
else
    echo "Anydesk is already installed."
fi

##################################################################

./setupOtherApps.sh

echo "Setup completed!"
