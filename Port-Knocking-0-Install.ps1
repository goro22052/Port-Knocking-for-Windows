
#Start-Transcript -Path C:\Install\Port-Knocking\log01.txt -Append -Force

[xml]$xmlConfig = Get-Content -Path ("C:\Install\Port-Knocking\settings.xml")
$port1 = $xmlConfig.config.system.port1
$port2 = $xmlConfig.config.system.port2
$RDPport = $xmlConfig.config.system.RDPport
$PortsListener = $port1, $port2
$SafeIPs = (($xmlConfig.config.system.SafeIPs).Split(", ")).Trim()

#Create new  fwrules
New-NetFirewallRule -DisplayName '!RDP-for-SafeIPs' -Direction Inbound -LocalPort $RDPport -Protocol TCP -Action Allow –RemoteAddress $SafeIPs  -Enabled True  -Verbose 


New-NetFirewallRule -DisplayName '!RDP-for-port-knocking' -Direction Inbound -LocalPort $RDPport -Protocol TCP -Action Allow –RemoteAddress $SafeIPs -Enabled True -Verbose


New-NetFirewallRule -DisplayName '!For-port-knocking-Listener' -Direction Inbound -LocalPort $PortsListener -Protocol TCP -Action Allow   -Enabled True  -Verbose

#Find and disable old fwrules
Get-NetFirewallPortFilter | Where-Object LocalPort -eq $RDPport |  Get-NetFirewallRule | Where-Object {($_.DisplayName -ne '!RDP-for-port-knocking') -and (($_.DisplayName -ne '!RDP-for-SafeIPs'))} | Disable-NetFirewallRule


#Create Shadule-main
Register-ScheduledTask  -TaskName 'Port-Knocking-2-main-task' -Xml (Get-Content 'C:\Install\Port-Knocking\Tasks\Port-Knocking-2-main-task.xml'  | Out-String) -Force

#Create Shadule-Zero-Time
Register-ScheduledTask  -TaskName 'Port-Knocking-3-ZeroTime' -Xml (Get-Content 'C:\Install\Port-Knocking\Tasks\Port-Knocking-3-ZeroTime.xml'  | Out-String) -Force

Start-ScheduledTask -TaskName 'Port-Knocking-2-main-task'