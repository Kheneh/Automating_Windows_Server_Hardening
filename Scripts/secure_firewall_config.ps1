# Function to configure the firewall
function Configure-Firewall {
    Write-Output "Configuring firewall rules"

    # Clear existing rules
    Write-Output "Clearing existing firewall rules"
    Get-NetFirewallRule | Remove-NetFirewallRule

    # Block all incoming connections by default
    Write-Output "Blocking all incoming connections by default"
    Set-NetFirewallProfile -Profile Domain,Public,Private -DefaultInboundAction Block -DefaultOutboundAction Block

    # Enable firewall logging
    Write-Output "Enabling firewall logging"
    Set-NetFirewallProfile -Profile Domain,Public,Private -LogAllowed True -LogBlocked True -LogFileName "C:\Windows\System32\LogFiles\Firewall\pfirewall.log" -LogMaxSizeKilobytes 32767

    # Allow necessary incoming connections
    Write-Output "Allowing necessary incoming connections"

    # Remote Desktop Protocol (RDP)
    New-NetFirewallRule -DisplayName "Allow RDP" -Direction Inbound -Protocol TCP -LocalPort 3389 -Action Allow

    # Hypertext Transfer Protocol (HTTP)
    New-NetFirewallRule -DisplayName "Allow HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow

    # Hypertext Transfer Protocol Secure (HTTPS)
    New-NetFirewallRule -DisplayName "Allow HTTPS" -Direction Inbound -Protocol TCP -LocalPort 443 -Action Allow

    # Domain Name System (DNS)
    New-NetFirewallRule -DisplayName "Allow DNS" -Direction Inbound -Protocol UDP -LocalPort 53 -Action Allow

    # Server Message Block (SMB) - internal use only
    New-NetFirewallRule -DisplayName "Allow SMB" -Direction Inbound -Protocol TCP -LocalPort 445 -Action Allow -Profile Domain

    # Simple Mail Transfer Protocol (SMTP)
    New-NetFirewallRule -DisplayName "Allow SMTP" -Direction Inbound -Protocol TCP -LocalPort 25 -Action Allow

    # File Transfer Protocol (FTP) Control
    New-NetFirewallRule -DisplayName "Allow FTP Control" -Direction Inbound -Protocol TCP -LocalPort 21 -Action Allow

    # File Transfer Protocol (FTP) Data
    New-NetFirewallRule -DisplayName "Allow FTP Data" -Direction Inbound -Protocol TCP -LocalPort 20 -Action Allow



    # Allow necessary outbound connections
    Write-Output "Allowing necessary outbound connections"

    # Outbound DNS
    New-NetFirewallRule -DisplayName "Allow Outbound DNS" -Direction Outbound -Protocol UDP -RemotePort 53 -Action Allow

    # Outbound HTTP
    New-NetFirewallRule -DisplayName "Allow Outbound HTTP" -Direction Outbound -Protocol TCP -RemotePort 80 -Action Allow

    # Outbound HTTPS
    New-NetFirewallRule -DisplayName "Allow Outbound HTTPS" -Direction Outbound -Protocol TCP -RemotePort 443 -Action Allow

    # Outbound SMTP
    New-NetFirewallRule -DisplayName "Allow Outbound SMTP" -Direction Outbound -Protocol TCP -RemotePort 25 -Action Allow

    # Outbound FTP Control
    New-NetFirewallRule -DisplayName "Allow Outbound FTP Control" -Direction Outbound -Protocol TCP -RemotePort 21 -Action Allow

    # Outbound FTP Data
    New-NetFirewallRule -DisplayName "Allow Outbound FTP Data" -Direction Outbound -Protocol TCP -RemotePort 20 -Action Allow

    # Block all other outbound traffic
    Write-Output "Blocking all other outbound connections by default"
    New-NetFirewallRule -DisplayName "Block All Other Outbound Traffic" -Direction Outbound -Action Block

    Write-Output "Firewall configuration completed"
}

# Main script execution
Write-Output "Starting firewall configuration script"
Configure-Firewall
Write-Output "Firewall configuration script completed"
