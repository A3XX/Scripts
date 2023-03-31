#!/bin/bash

# Install WireGuard
sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get update
sudo apt-get install wireguard -y

# Generate the server configuration file
sudo mkdir /etc/wireguard
sudo touch /etc/wireguard/wg0.conf
sudo chmod 600 /etc/wireguard/wg0.conf

# Generate a private key and public key for the server
server_private_key=$(wg genkey)
server_public_key=$(echo "$server_private_key" | wg pubkey)

# Write the server configuration to the configuration file
cat << EOF | sudo tee /etc/wireguard/wg0.conf > /dev/null
[Interface]
Address = 10.0.0.1/24
PrivateKey = $server_private_key
ListenPort = 51820

EOF

# Enable IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1

# Start the WireGuard service
sudo systemctl enable --now wg-quick@wg0.service

# Add a user to the VPN
add_user() {
    # Ask for the user's name
    read -p "Enter the username: " username

    # Generate a private key and public key for the user
    user_private_key=$(wg genkey)
    user_public_key=$(echo "$user_private_key" | wg pubkey)

    # Add the user's public key to the server configuration file
    cat << EOF | sudo tee -a /etc/wireguard/wg0.conf > /dev/null
[Peer]
PublicKey = $user_public_key
AllowedIPs = 10.0.0.2/32

EOF

    # Generate a QR code for the user's configuration
    qrencode -t ansiutf8 < <(wg-quick strip wg0 | sed "s/0.0.0.0/$server_public_key/;s/\/0/\/24/;s/10.0.0.1/$user_private_key/") | sed "s/    /\u2588/g"

    echo "User $username added successfully."
}

# Remove a user from the VPN
remove_user() {
    # Ask for the user's name
    read -p "Enter the username: " username

    # Remove the user's public key from the server configuration file
    sudo sed -i "/PublicKey = $username/d" /etc/wireguard/wg0.conf

    echo "User $username removed successfully."
}

# Loop through the menu options
while true; do
    echo "WireGuard VPN"
    echo "1. Add user"
    echo "2. Remove user"
    echo "3. Quit"

    read -p "Enter your choice: " choice

    case $choice in
        1) add_user ;;
        2) remove_user ;;
        3) exit ;;
        *) echo "Invalid choice." ;;
    esac

    echo
done
