function global:Get-MsolDomainLW {
    param (
        $Authentication,
        $Capability,
        $DomainName,
        $Status,
        $TenantId
    )

    $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/ListDomains"

    if ($TenantID) {
        $TenantIDVal = "<b:TenantId>$TenantID</b:TenantId>"
    }
    else {
        $TenantIDVal = '<b:TenantId i:nil="true" />'
    }

    if ($Authentication) {
        $AuthenticationVal = "<c:Authentication>$Authentication</c:Authentication>"
    }
    else {
        $AuthenticationVal = '<c:Authentication i:nil="true" />'
    }

    if ($Capability) {
        $CapabilityVal = "<c:Capability>$Capability</c:Capability>"
    }
    else {
        $CapabilityVal = '<c:Capability i:nil="true" />'
    }

    if ($Status) {
        $StatusVal = "<c:Status>$Status</c:Status>"
    }
    else {
        $StatusVal = '<c:Status i:nil="true" />'
    }

    $Body = @"
<ListDomains xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$($TenantIDVal)<b:VerifiedDomain i:nil="true"/><b:SearchFilter xmlns:c="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration">$($AuthenticationVal)$($CapabilityVal)$($StatusVal)</b:SearchFilter></request></ListDomains>
"@

    if ($DomainName) {
        $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/GetDomain"
        $Body = @"
<GetDomain xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$($TenantIDVal)<b:VerifiedDomain i:nil="true" /><b:DomainName>$DomainName</b:DomainName></request></GetDomain>
"@
    }


    $XML = Invoke-MSOnlineRequest -Action $Action -Body $Body

    If ($DomainName) {
        $DomainsXML = $XML.Envelope.Body.GetDomainResponse.GetDomainResult.ReturnValue
    }
    else {
        $DomainsXML = $XML.Envelope.Body.ListDomainsResponse.ListDomainsResult.ReturnValue.Domain
    }

    $Domains = Foreach ($Domain in $DomainsXML) {
        $ReturnObj = [pscustomobject]@{
            Authentication     = $Domain.Authentication
            Capabilities       = $Domain.Capabilities
            IsDefault          = $Domain.IsDefault
            IsInitial          = $Domain.IsInitial
            Name               = $Domain.Name
            RootDomain         = $Domain.RootDomain
            Status             = $Domain.Status
            VerificationMethod = $Domain.VerificationMethod
        }

        $ReturnObj = Get-NullCleaned -OriginalItem $Domain -ObjectToClean $ReturnObj
        $ReturnObj

    }

    Return $Domains

}