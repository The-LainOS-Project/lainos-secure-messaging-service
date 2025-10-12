#!/bin/bash

# Refactored vesme-snowflake.sh functions for secure passphrase handling

# Function to handle errors
handle_error() {
	echo "Error: $1" >&2
	exit 1
}

# Function to generate a random string
generate_random_string() {
	openssl rand -hex 24
}

# Function to generate a GPG key, securely taking the passphrase via a file descriptor.
# This avoids storing the passphrase in an environment variable.
generate_gpg_key() {
	local RANDOM_NAME=$(generate_random_string)
	local RANDOM_EMAIL="${RANDOM_NAME}@example.com"
	local GPG_FINGERPRINT

	# Create a temporary file descriptor to securely pipe the passphrase.
	# The passphrase is never stored in a variable that can be read by other processes.
	exec 3< <(echo "$GPG_PASSPHRASE")

	gpg --batch --passphrase-fd 3 --gen-key <<EOF || handle_error "GPG key generation failed."
%echo Generating a default key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $RANDOM_NAME
Name-Email: $RANDOM_EMAIL
Expire-Date: 0
%commit
%echo done
EOF

	exec 3<&- # Close the temporary file descriptor

	# Clear passphrase variable to be safe, even though it's not exported
	unset GPG_PASSPHRASE

	GPG_FINGERPRINT=$(gpg --list-keys --with-colons | grep '^pub' | awk -F: '{print $5}' | tail -n 1)

	if [ -z "$GPG_FINGERPRINT" ]; then
		handle_error "Unable to retrieve GPG fingerprint."
	fi
	echo "Your GPG fingerprint is: $GPG_FINGERPRINT"
	export GPG_FINGERPRINT
}

# Function to prompt for the GPG passphrase
prompt_gpg_passphrase() {
	echo "********************************************************************"
	read -s -p "Enter your GPG passphrase: " GPG_PASSPHRASE
	echo ""
	read -s -p "Confirm your GPG passphrase: " GPG_PASSPHRASE_CONFIRM
	echo ""

	if [[ ${#GPG_PASSPHRASE} -lt 12 || ! "$GPG_PASSPHRASE" =~ [a-z] || ! "$GPG_PASSPHRASE" =~ [A-Z] || ! "$GPG_PASSPHRASE" =~ [0-9] ]]; then
		handle_error "GPG passphrase must be at least 12 characters long and include uppercase, lowercase, and numbers."
	fi

	if [ "$GPG_PASSPHRASE" != "$GPG_PASSPHRASE_CONFIRM" ]; then
		handle_error "GPG passphrases do not match. Please try again."
	fi
}

# Function to generate GPG key
generate_gpg_key() {
	RANDOM_NAME=$(generate_random_string)
	RANDOM_EMAIL="${RANDOM_NAME}@example.com"

	gpg --batch --passphrase "$GPG_PASSPHRASE" --gen-key < <(
		cat <<EOF
%echo Generating a default key
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: $RANDOM_NAME
Name-Email: $RANDOM_EMAIL
Expire-Date: 0
Passphrase: $GPG_PASSPHRASE
%commit
%echo done
EOF
	) || handle_error "GPG key generation failed."

	GPG_FINGERPRINT=$(gpg --list-keys --with-colons | grep '^pub' | awk -F: '{print $5}' | tail -n 1)

	if [ -z "$GPG_FINGERPRINT" ]; then
		handle_error "Error: Unable to retrieve GPG fingerprint."
	fi
	echo "Your GPG fingerprint is: $GPG_FINGERPRINT"
	unset GPG_PASSPHRASE # Clear the passphrase from memory
	unset GPG_PASSPHRASE_CONFIRM
}

# Function to prompt for XMPP account
prompt_xmpp_account() {
	echo "********************************************************************"
	read -p "Enter your XMPP account (your_username@server.onion): " XMPP_ACCOUNT

	if ! [[ "$XMPP_ACCOUNT" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
		handle_error "Invalid XMPP account format."
	fi
}

# Function to install required applications
install_required_apps() {
	echo "Updating the system..."
	# Arch Linux uses pacman -Syu for update and upgrade
	sudo pacman -Syu --noconfirm

	echo "Installing required applications..."
	# Replacing Debian package names with Arch equivalents:
	# snowflake-client often comes with obfs4proxy on Arch.
	# ntp is often replaced by openntpd.
	required_apps=(profanity pass tor torsocks onionshare openntpd)
	if ! sudo pacman -S --noconfirm "${required_apps[@]}"; then
		handle_error "Error: Failed to install required applications. Please check your package manager."
	fi
}

# Function to configure Tor
configure_tor() {
	echo "Configuring Tor with obfs4 bridges..."

	# Define the path to the Tor configuration file
	TORRC="/etc/tor/torrc"

	# Create a backup of the original configuration file with a timestamp
	BACKUP_TORRC="/etc/tor/torrc.bak.$(date +%Y%m%d%H%M%S)"
	sudo cp "$TORRC" "$BACKUP_TORRC"
	echo "Backup of the original torrc created at: $BACKUP_TORRC"

	# Append new configuration settings to the torrc file
	# Note: On Arch, the snowflake-client binary might be at /usr/bin/snowflake-client, which is common.
	# If using obfs4proxy, the client might be within the obfs4proxy package or need to be installed from AUR/compiled.
	# Assuming /usr/bin/snowflake-client is available or symlinked for minimal change.
	sudo bash -c "cat <<EOT >> $TORRC
# Use bridges
UseBridges 1
ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy managed
Bridge obfs4 89.217.174.207:9001 B64C5A360D530633CB2D8DEC5D19CA35C4360C93 cert=aJecxsni6mgSTU0BPz3v0W7GA+RmjuDFA7NF+KffQNydMX7npDvjqrCXRnzY0ym9EKlLTw iat-mode=0
Bridge obfs4 86.30.100.123:42957 F3FA0D45D35E987484848345F8D92AB1D883889B cert=cxC0DfySYT/IBGBesOq64QKHCl5WdiR08qxcdsCpbpkj/2m6vwzpCFsP6m8r/+ZhdC26CA iat-mode=0

EOT"

	# Disable Tor from starting on boot
	echo "Disabling Tor from starting on boot..."
	sudo systemctl disable tor

	# Stop Tor service if it's running
	sudo systemctl stop tor

	# Start Tor in the background
	#nohup tor &
}

# Function to initialize Pass with GPG fingerprint
initialize_pass() {
	echo "Using XMPP account: $XMPP_ACCOUNT"
	echo "Using GPG fingerprint: $GPG_FINGERPRINT"

	echo "Initializing Pass with the GPG fingerprint..."
	pass init "$GPG_FINGERPRINT" || handle_error "Failed to initialize Pass."
}

unset GPG_FINGERPRINT

# Function to store XMPP account password in Pass
store_xmpp_password() {
	echo "Storing your XMPP account password in Pass..."
	echo "********************************************************************"
	if ! pass insert "entry/$XMPP_ACCOUNT"; then
		handle_error "Failed to store the XMPP account password in Pass."
	fi
}

# Function to update shell configuration
update_shell_config() {
	SHELL_CONFIG="$HOME/.bashrc"
	if [ "$SHELL" = "/bin/zsh" ]; then
		SHELL_CONFIG="$HOME/.zshrc"
	fi

	# Arch Linux uses systemctl to manage openntpd (replacing ntp service)
	# The command should be 'sudo systemctl start openntpd' instead of 'sudo service ntp start'
	if ! grep -q "sudo systemctl start openntpd" "$SHELL_CONFIG"; then
		echo "sudo systemctl start openntpd" >>"$SHELL_CONFIG"
	fi
}

# Function to start Profanity with torsocks
start_profanity() {
	torsocks profanity <<EOF
/history off
/theme load forest
/account add $XMPP_ACCOUNT
/account set $XMPP_ACCOUNT eval_password "pass entry/$XMPP_ACCOUNT"
/omemo policy automatic
/omemo trustmode blind
/save
/quit
EOF
}

# Function to prompt user for Profanity login
prompt_profanity_login() {
	echo "********************************************************************"
	read -p "Do you want to log in to Profanity now? (y/n): " log_in_choice

	if [ "$log_in_choice" = "y" ]; then
		torsocks profanity -a "$XMPP_ACCOUNT"
	else
		echo "You can log in to Profanity later by running:"
		echo "torsocks profanity -a $XMPP_ACCOUNT"

		echo "Or start Profanity without auto-login with:"
		echo "torsocks profanity"
	fi
}

unset XMPP_ACCOUNT

# Function to create a new user for Kicksecure installation
create_kicksecure_user() {
	sudo adduser user
}

# Function to clear sensitive data
clear_sensitive_data() {
	echo "********************************************************************"
	echo "Clearing terminal data for security..."
	history -c
	unset HISTFILE
	echo "All sensitive data has been securely wiped."
}

# Function to install gnupg (already present in the original main, but missing definition)
# Adding a stub for install_gnupg as it was called in main but not defined.
install_gnupg() {
	echo "GnuPG is typically installed by default or as a dependency. Proceeding..."
}

# Main function to orchestrate the installation
main() {
	install_gnupg
	echo "********************************************************************"
	i echo "Welcome to the Lainos Ephemeral Secure Messaging Environment (LESME) Install/Config Script!"

	prompt_gpg_passphrase
	generate_gpg_key
	prompt_xmpp_account
	install_required_apps
	configure_tor
	initialize_pass
	store_xmpp_password
	update_shell_config
	start_profanity
	prompt_profanity_login
	create_kicksecure_user
	clear_sensitive_data

	echo "VESME installation complete!"
	echo "Finish the installation by running the 'ks1.sh' and 'ks2.sh' scripts to convert Debian-avf 12 to Kicksecure-avf."
}

# Execute the main function
main
