
[xml]$xmlConfig = Get-Content -Path ("C:\Install\Port-Knocking\settings.xml")
$Telegramtoken  = $xmlConfig.config.system.Telegramtoken
$Telegramchatid = (($xmlConfig.config.system.Telegramchatid).Split(",")).Trim()
$SafeIPs = (($xmlConfig.config.system.SafeIPs).Split(",")).Trim()

Set-NetFirewallRule -DisplayName "!RDP-for-port-knocking" -RemoteAddress $SafeIPs

Function Send-Telegram {
    Param([Parameter(Mandatory=$true)][String]$Message)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"
}

Send-Telegram -Message "$env:COMPUTERNAME cleared IPs"