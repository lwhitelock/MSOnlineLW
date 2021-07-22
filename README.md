# MSOnlineLW

This module implements the most commonly used methods from the MSOnline module. The intention of this module is to only replicate the most commonly used commands and any things which can only be done through the MSOnline module and none of the more modern modules or the GraphAPI
  

# Installation instructions

This module has been published to the PowerShell Gallery. In your script edit:  

    "install-module MSOnline" to be "install-module MSOnlineLW"
    "import-module MSOnlineLW" to be "import-module MSOnlineLW"

No other changes should be needed.


# Usage
This module should be used inconjunction with my PartnerCenterLW module https://github.com/lwhitelock/PartnerCenterLW

Connect-MsolService will only work with the secure application module:
```
$aadGraphToken = New-PartnerAccessToken -ApplicationId $ApplicationId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.windows.net/.default' -ServicePrincipal -Tenant $tenantID
$graphToken = New-PartnerAccessToken -ApplicationId $ApplicationId -Credential $credential -RefreshToken $refreshToken -Scopes 'https://graph.microsoft.com/.default' -ServicePrincipal -Tenant $tenantID
$MSOLConnection = Connect-MsolService -AdGraphAccessToken $aadGraphToken.AccessToken -MsGraphAccessToken $graphToken.AccessToken
```
  
The currently implemented commands are:
```
Connect-MsolService
Get-MsolUser
Get-MSOnlineRequest
Get-MsolPartnerContract
Get-MsolDomain
```

If there are additional actions which can only be done in MSOnline and not Graph please open an issue and I will get them added.

