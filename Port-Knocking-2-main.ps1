
[xml]$xmlConfig = Get-Content -Path ("C:\Install\Port-Knocking\settings.xml")
$Telegramtoken  = $xmlConfig.config.system.Telegramtoken
$Telegramchatid = (($xmlConfig.config.system.Telegramchatid).Split(",")).Trim()
$port1 = $xmlConfig.config.system.port1
$port2 = $xmlConfig.config.system.port2

Function Send-Telegram {
    Param([Parameter(Mandatory=$true)][String]$Message)
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    $Response = Invoke-RestMethod -Uri "https://api.telegram.org/bot$($Telegramtoken)/sendMessage?chat_id=$($Telegramchatid)&text=$($Message)"
}

While ($True) {
    $Listener1 = [System.Net.Sockets.TcpListener][int]$port1;
    $Listener1.Start();
    #$CurDir = (Get-Location).Path
    #$Logfile = $CurDir + 'log-knocking.txt '
  

    ###knock for the first time
    While($true){

        $client1 = $Listener1.AcceptTcpClient();
        $IP1 = $client1.client.RemoteEndPoint.Address.IPAddressToString
        $Client1.Close();
        break

    } 
    $Listener1.Stop()

    ###knock for the second time
        $IP2 = Start-Job -Name port2 {
        [xml]$xmlConfig = Get-Content -Path ("C:\Install\Port-Knocking\settings.xml")
		$port2 = $xmlConfig.config.system.port2
        $Listener2 = [System.Net.Sockets.TcpListener][int]$port2;
        $Listener2.Start();
        $Client2 = $Listener2.AcceptTcpClient();
        #Write-Host "Connection on port $port2 from $($Client2.client.RemoteEndPoint.Address)";
        $IP2 = $client2.client.RemoteEndPoint.Address.IPAddressToString
        $Client2.Close();
        $Listener2.Stop()
        return $IP2
        } | Wait-Job -Timeout 4 | Receive-Job
    Stop-Job -Name port2
    Remove-Job -Name port2 
	
    #Write-Host $IP1
    #Write-Host $IP2

    ###compare IP and add to FWrule
    if ($IP1 -eq $IP2){
        #Write-Host "IP is correct!" -ForegroundColor Yellow
        # $CurrentIPs = (Get-NetFirewallRule -DisplayName "!RDP-for-port-knocking" | Get-NetFirewallAddressFilter ).RemoteAddress
        # For Windows Server 2016(100% worked) uncomment next line and comment previous one.
        $CurrentIPs = @( (Get-NetFirewallRule -DisplayName "!RDP-for-port-knocking" | Get-NetFirewallAddressFilter).RemoteAddress )
        $CurrentIPs += $IP2
        Set-NetFirewallRule -DisplayName "!RDP-for-port-knocking" -RemoteAddress  $CurrentIPs 
		#Write-Host $CurrentIPS
		Send-Telegram -Message "$env:COMPUTERNAME added IP - $IP1"
    }	
	else {
		Send-Telegram -Message "$env:COMPUTERNAME was scanned from  $IP1"
	}
		
    $IP1 = $null
    $IP2 = $null
	

}