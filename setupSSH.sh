#!/bin/bash

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

# Generate SSH key
ssh-keygen -t rsa -C "mail" -f "$HOME/.ssh/id_rsa_p_github" -N "pass"
if [ $? -ne 0 ]; then
    echo "Failed to generate SSH key"
    exit 1
fi

# Create SSH config file
cat <<EOF > "$HOME/.ssh/config"
# github account
Host github.p.com
HostName github.com
PreferredAuthentications publickey
IdentityFile ~/.ssh/id_rsa_p_github
EOF

if [ $? -ne 0 ]; then
    echo "Failed to create SSH config file"
    exit 1
fi

echo "SSH setup completed successfully"

