#!/bin/bash

# Load environment variables from .env file, ignoring comments and empty lines
if [ -f .env ]; then
    export $(grep -v '^\s*#' .env | grep -v '^\s*$' | xargs)
else
    echo ".env file not found"
    exit 1
fi

# User details
NAME="${NAME}"
MAIL="${MAIL}"
PASS_GITHUB_P="${PASS_GITHUB_P}"
PASS_GITHUB_R="${PASS_GITHUB_R}"
PASS_GITLAB_P="${PASS_GITLAB_P}"
PASS_BITBUCKET_P="${PASS_BITBUCKET_P}"
PASS_AZURE_P="${PASS_AZURE_P}"

# Configure git global settings, ensuring no multiple values are set
git config --global --replace-all user.name "$NAME"
git config --global --replace-all user.email "$MAIL"

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

Host github.r.com
  HostName github.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_r_github

######################
#   gitlab accounts  #
######################

Host gitlab.p.com
  HostName gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_gitlab

##########################
#   bitbucket accounts   #
##########################

Host bitbucket.p.org
  HostName bitbucket.org
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_bitbucket

######################
#   azure accounts   #
######################

Host ssh.dev.azure.p.com
  HostName ssh.dev.azure.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/id_rsa_p_azure
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
  local passphrase="$2"
  
  # Expand ~ to the home directory path
  key_file="${key_file/#\~/$HOME}"

  if [ -f "$key_file" ]; then
    echo "Key file $key_file already exists. Skipping..."
  else
    echo "Creating RSA key for $key_file..."
    ssh-keygen -t rsa -b 2048 -f "$key_file" -N "$passphrase"
  fi
}

# Mapping of key files to passphrases
declare -A key_passphrase_map
key_passphrase_map["id_rsa_p_github"]="$PASS_GITHUB_P"
key_passphrase_map["id_rsa_r_github"]="$PASS_GITHUB_R"
key_passphrase_map["id_rsa_p_gitlab"]="$PASS_GITLAB_P"
key_passphrase_map["id_rsa_p_bitbucket"]="$PASS_BITBUCKET_P"
key_passphrase_map["id_rsa_p_azure"]="$PASS_AZURE_P"

# Read the SSH config file and process IdentityFile entries
while IFS= read -r line; do
  if [[ "$line" =~ IdentityFile ]]; then
    # Extract the path to the key file
    key_file=$(echo "$line" | awk '{print $2}')
    
    # Get the base name of the key file
    key_base=$(basename "$key_file")

    # Determine the appropriate passphrase based on the key base name
    passphrase="${key_passphrase_map[$key_base]}"
    
    if [ -n "$passphrase" ]; then
      create_rsa_key "$key_file" "$passphrase"
    else
      echo "No matching passphrase found for $key_file"
    fi
  fi
done < "$SSH_CONFIG"

echo "SSH setup completed successfully"
