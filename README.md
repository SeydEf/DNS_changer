# DNS Changer Script

This Bash script provides a simple interactive menu to change the DNS settings for your active wireless connection on Linux systems using NetworkManager.

## Features

- Displays the current active wireless connection name
- Shows the current DNS settings
- Provides a list of predefined DNS servers to choose from
- Allows easy selection using arrow keys
- Updates the DNS settings for the selected connection
- Restarts the connection to apply changes

## Prerequisites

- Linux system with NetworkManager
- `nmcli` command-line tool (usually comes pre-installed with NetworkManager)

## Usage

1. Make the script executable:
   ```
   chmod +x dns_changer.sh
   ```

2. Run the script with root privileges:
   ```
   sudo ./dns_changer.sh
   ```

3. Use the UP and DOWN arrow keys to navigate through the DNS server options.

4. Press ENTER to select a DNS server.

5. The script will update the DNS settings and restart the connection.

## Available DNS Servers

- Default (No custom DNS)
- Shecan
- Electro
- Begzar
- 403
- Radar
- Google
- CloudFlare

**Note: This list is more useful for Iranians, you can change it to your liking.**

## Customization

You can modify the `dns_servers_name` and `dns_servers` arrays in the script to add, remove, or change the available DNS options.

## Notes

- The script only modifies the DNS settings for the currently active wireless connection.
- You need root privileges to modify network settings.
- After changing the DNS, the script will automatically restart the network connection to apply the changes.
