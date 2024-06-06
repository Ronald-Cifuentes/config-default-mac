#!/bin/bash

# Ensure the script itself is executable
chmod +x start_ssh_agent.sh

# User details
NAME="John Doe"
MAIL=johndoe@example.com
PASS=pass
INIT_RSA=id_rsa_p_github


# Configure git global settings
git config --global user.name "$NAME"
git config --global user.email "$MAIL"

# Create .ssh directory if it doesn't exist
if [ ! -d "$HOME/.ssh" ]; then
    mkdir "$HOME/.ssh"
    if [ $? -ne 0 ]; then
        echo "Failed to create .ssh directory"
        exit 1
    fi
else
    echo ".ssh directory already exists"
fi

# Change to the .ssh directory
cd "$HOME/.ssh"
if [ $? -ne 0 ]; then
    echo "Failed to change directory to .ssh"
    exit 1
fi

# Generate SSH key if it doesn't exist
if [ ! -f "$HOME/.ssh/$INIT_RSA" ]; then
    ssh-keygen -t rsa -C "$MAIL" -f "$HOME/.ssh/$INIT_RSA" -N "$PASS"
    if [ $? -ne 0 ]; then
        echo "Failed to generate SSH key"
        exit 1
    fi
else
    echo "SSH key already exists"
fi

# Create SSH config file
cat <<EOF > "$HOME/.ssh/config"
# github account
Host github.p.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/$INIT_RSA
  UseKeychain yes
  AddKeysToAgent yes
EOF

if [ $? -ne 0 ]; then
    echo "Failed to create SSH config file"
    exit 1
fi

echo "SSH setup completed successfully"

# Set environment variable to suppress deprecation warning
export APPLE_SSH_ADD_BEHAVIOR="--apple-use-keychain"

# Start the SSH agent
eval "$(ssh-agent -s)"
if [ $? -ne 0 ]; then
    echo "Failed to start SSH agent"
    exit 1
fi

# Add the SSH private key to the agent and macOS keychain
/usr/bin/ssh-add --apple-use-keychain "$HOME/.ssh/$INIT_RSA"
if [ $? -ne 0 ]; then
    echo "Failed to add SSH key to the agent"
    exit 1
fi

# Verify that the key has been added
ssh-add -l
if [ $? -ne 0 ]; then
    echo "Failed to list SSH keys"
    exit 1
fi

echo "SSH agent started and GitHub key added to macOS keychain."

# Add the script to .zshrc for automatic startup
if ! grep -q "source /path/to/start_ssh_agent.sh" "$HOME/.zshrc"; then
    echo "source /path/to/start_ssh_agent.sh" >> "$HOME/.zshrc"
    if [ $? -ne 0 ]; then
        echo "Failed to add script to .zshrc"
        exit 1
    fi
else
    echo "Script already present in .zshrc"
fi

echo "SSH path added to .zshrc."
