$ErrorActionPreference  =  'SilentlyContinue'

[xml]$xmlConfig = Get-Content -Path ("C:\Install\Port-Knocking\settings.xml")
$port1 = $xmlConfig.config.system.port1
$port2 = $xmlConfig.config.system.port2
$RDPport = $xmlConfig.config.system.RDPport

$RDPport0 =  (Get-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp' -name "PortNumber").PortNumber
$RDPportState = Get-NetTCPConnection -LocalPort $RDPport0 -State Listen

#Check RDP port
if (($RDPport -eq $RDPport0) -and ($RDPportState)){
    Write-Host "RDP port - $RDPport0 and port is OK" -ForegroundColor Green
}
else{
    Write-Host "RDP port is not $RDPport0 or  port in not liten, check please..." -ForegroundColor Red
     
}

#Check ports Listeners
$port1State = Get-NetTCPConnection -LocalPort $port1 -State Listen
$port2State = Get-NetTCPConnection -LocalPort $port2 -State Listen

if (($port1State -eq $null)  -and ($port2State -eq $null)){
     Write-Host "This ports($port1, $port2) can be use for Port-Knocning" -ForegroundColor Green
   
}
else{
    Write-Host "This ports($port1, $port2) can not be use for Port-Knocning" -ForegroundColor Red
   
}
