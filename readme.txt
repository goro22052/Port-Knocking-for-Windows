Copy to
C:\Install\Port-Knocking\

Set. All fields are required.
"C:\Install\Port-Knocking\settings.xml"
Telegramtoken - Telegram Bot Token. Use https://t.me/BotFather to register a bot and get Token.
Create a Group or Channel, add Bot there. Find the Group or Channel ID using postman or any other API utility. 
Remember Groups has -, channels doesn't
Change SafeIPs to the Ip you to whitelist. Without it it will not work.

Check that the settings are correct. If the ports are in use, an error is thrown.
C:\Install\Port-Knocking\Check-correct-settings.ps1

Run as admin
C:\Install\Port-Knocking\Port-Knocking-0-Install.ps1

If there are errors with permitions while runing scripts, use in Powershell before runing a command. 
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass


Paping is a free utility to ping server with needed port. You can downloand it here: 
https://code.google.com/archive/p/paping/downloads
