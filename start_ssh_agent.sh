#!/bin/bash

# User details
NAME="Jhon Doe"
MAIL="jhondoe@gmail.com"
PASS="mypass"

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


# Create SSH config file
cat <<EOF > "$HOME/.ssh/config"
#######################
#   github accounts   #
#######################

Host github.p.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_github
  UseKeychain yes
  AddKeysToAgent yes

Host github.r.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_r_github
  UseKeychain yes
  AddKeysToAgent yes

######################
#   gitlab accounts  #
######################

Host gitlab.p.com
  HostName gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_gitlab
  UseKeychain yes
  AddKeysToAgent yes

##########################
#   bitbucket accounts   #
##########################

Host bitbucket.p.org
  HostName bitbucket.org
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_bitbucket
  UseKeychain yes
  AddKeysToAgent yes

######################
#   azure accounts   #
######################

Host ssh.dev.azure.p.com
  HostName ssh.dev.azure.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_azure
  UseKeychain yes
  AddKeysToAgent yes
EOF

if [ $? -ne 0 ]; then
    echo "Failed to create SSH config file"
    exit 1
fi

# Check if the SSH config file exists
SSH_CONFIG="$HOME/.ssh/config"
if [ ! -f "$SSH_CONFIG" ]; then
  echo "SSH config file not found at $SSH_CONFIG"
  exit 1
fi


# Function to create an RSA key pair with a passphrase
create_rsa_key() {
  local key_file="$1"
  
  # Expand ~ to the home directory path
  key_file="${key_file/#\~/$HOME}"

  if [ -f "$key_file" ]; then
    echo "Key file $key_file already exists. Skipping..."
  else
    echo "Creating RSA key for $key_file..."
    ssh-keygen -t rsa -b 2048 -f "$key_file" -N "$PASS"
  fi
}

# Read the SSH config file and process IdentityFile entries
while IFS= read -r line; do
  if [[ "$line" =~ IdentityFile ]]; then
    # Extract the path to the key file
    key_file=$(echo "$line" | awk '{print $2}')
    create_rsa_key "$key_file"
  fi
done < "$SSH_CONFIG"

echo "SSH setup completed successfully"
