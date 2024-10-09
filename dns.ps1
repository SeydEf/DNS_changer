$dns_servers = @{
    "Default" = @()
    "Shecan" = @("178.22.122.100", "185.51.200.2")
    "Electro" = @("78.157.42.101", "78.157.42.101")
    "Begzar" = @("185.55.226.26", "185.55.225.25")
    "403" = @("10.202.10.202", "10.202.10.102")
    "Radar" = @("10.202.10.10", "10.202.10.11")
    "Google" = @("8.8.8.8", "8.8.4.4")
    "CloudFlare" = @("1.1.1.1", "1.0.0.1")
}

function Show-Menu {
    param (
        [int]$SelectedIndex,
        [bool]$IsAdmin
    )
    Clear-Host
    if ($IsAdmin) {
        Write-Host "WARNING: Running in administrator mode. Changes will be permanent." -ForegroundColor Yellow
    } else {
        Write-Host "NOTE: Running in normal mode. Changes will be temporary and reset after reboot or network change." -ForegroundColor Cyan
    }
    Write-Host ""
    Write-Host "Select a DNS server using UP/DOWN arrows and press ENTER:"
    $dns_servers.Keys | ForEach-Object {
        $index = [Array]::IndexOf($dns_servers.Keys, $_)
        if ($index -eq $SelectedIndex) {
            Write-Host "> $_" -ForegroundColor Green
        } else {
            Write-Host "  $_"
        }
    }
}

function Get-ActiveNetworkAdapter {
    return Get-NetAdapter | Where-Object { $_.Status -eq "Up" -and $_.InterfaceDescription -match "Wi-Fi|Wireless" } | Select-Object -First 1
}

function Test-Admin {
    $currentUser = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    return $currentUser.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Set-DNSServers {
    param (
        [string]$AdapterName,
        [string[]]$DNSServers
    )
    $isAdmin = Test-Admin
    try {
        if ($isAdmin) {
            if ($DNSServers.Count -eq 0) {
                Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ResetServerAddresses -ErrorAction Stop
            } else {
                Set-DnsClientServerAddress -InterfaceAlias $AdapterName -ServerAddresses $DNSServers -ErrorAction Stop
            }
        } else {
            if ($DNSServers.Count -eq 0) {
                netsh interface ip set dns $AdapterName dhcp | Out-Null
            } else {
                $primary = $DNSServers[0]
                $secondary = if ($DNSServers.Count -gt 1) { $DNSServers[1] } else { $null }
                
                netsh interface ip set dns $AdapterName static $primary | Out-Null
                if ($secondary) {
                    netsh interface ip add dns $AdapterName $secondary index=2 | Out-Null
                }
            }
        }
        Write-Host "DNS settings updated successfully." -ForegroundColor Green
        if (-not $isAdmin) {
            Write-Host "Note: These changes are temporary and will reset after a reboot or network change." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Error: Unable to set DNS servers." -ForegroundColor Red
        Write-Host "Error details: $_" -ForegroundColor Red
    }
}

$isAdmin = Test-Admin
$adapter = Get-ActiveNetworkAdapter
if (-not $adapter) {
    Write-Host "No active wireless network adapter found." -ForegroundColor Red
    exit
}

$selectedIndex = 0
$keys = [array]($dns_servers.Keys)

while ($true) {
    Show-Menu -SelectedIndex $selectedIndex -IsAdmin $isAdmin
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    switch ($key.VirtualKeyCode) {
        38 {
            $selectedIndex = ($selectedIndex - 1 + $keys.Count) % $keys.Count
        }
        40 {
            $selectedIndex = ($selectedIndex + 1) % $keys.Count
        }
        13 {
            $selectedDNS = $keys[$selectedIndex]
            $dnsIPs = $dns_servers[$selectedDNS]
            Write-Host "`nYou selected: $selectedDNS" -ForegroundColor Cyan
            if ($dnsIPs.Count -eq 0) {
                Write-Host "Resetting DNS to default (DHCP)" -ForegroundColor Yellow
            } else {
                Write-Host "DNS IPs: $($dnsIPs -join ', ')" -ForegroundColor Cyan
            }
            Set-DNSServers -AdapterName $adapter.Name -DNSServers $dnsIPs
            Read-Host "Press Enter to exit"
            exit
        }
    }
}