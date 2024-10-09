# DNS Changer Script

This repository contains scripts for changing DNS settings on both Linux and Windows systems. The scripts provide an interactive menu to select predefined DNS servers or reset to default settings.

## Features

- Displays the current active network connection name
- Shows the current DNS settings
- Provides a list of predefined DNS servers to choose from
- Allows easy selection using arrow keys
- Updates the DNS settings for the selected connection
- Restarts the connection to apply changes

## Prerequisites

### Linux
- Bash shell
- NetworkManager
- `nmcli` command-line tool (usually comes pre-installed with NetworkManager)

### Windows
- Windows 10 or later
- PowerShell 5.1 or later

## Usage

### Linux
1. Make the script executable:
   ```
   chmod +x dns.sh
   ```
2. Run the script:
   ```
   ./dns.sh
   ```
3. Use the UP and DOWN arrow keys to navigate through the DNS server options.
4. Press ENTER to select a DNS server.

### Windows
1. Open PowerShell as Administrator
2. Navigate to the directory containing the script
3. Run the script:
   ```
   .\dns.ps1
   ```
4. Use the UP and DOWN arrow keys to navigate through the DNS server options.
5. Press ENTER to select a DNS server.

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

### Linux
You can modify the `dns_servers_name` and `dns_servers` arrays in the script to add, remove, or change the available DNS options.

### Windows
You can modify the `$dns_servers` hashtable in the script to add, remove, or change the available DNS options.

## Notes

- The Linux script modifies the DNS settings for the currently active wireless connection.
- The Windows script can modify DNS settings for any active network adapter, with a preference for Wi-Fi connections.
- After changing the DNS, both scripts will automatically restart the network connection to apply the changes.
- On Windows, running the script as administrator will make permanent changes, while running it without admin privileges will make temporary changes that reset after a reboot or network change.

## Contributing

Contributions are welcome! Please feel free to submit pull requests with improvements or additional features.
