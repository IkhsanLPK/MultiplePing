# **MultiplePing**
This PowerShell script allows you to automatically ping multiple IP addresses read from an external text file (iplist.txt). It's useful for network monitoring, diagnostics, or basic uptime checks.

✨ Features
- Reads target IP addresses from iplist.txt
- Performs single ping per IP and logs whether it's UP or DOWN
- Color-coded output in the console (green for UP, red for DOWN)
- Saves results to PingResult.txt for later analysis
- Provides a summary report of total UP/DOWN statuses
- Groups and summarizes results by subnet (based on the first 3 octets)

📁 File Structure
- **iplist.txt** – List of IPs to ping (one IP per line)
- **PingResult.txt** – Log file with timestamped results
- **MultiplePing.ps1** – Main PowerShell script

⚙️ How to Use
1. Make sure PowerShell is installed on your system.
2. Edit **iplist.txt** to include the IPs you want to monitor.
3. Run the script: **.\MultiplePing.ps1**
