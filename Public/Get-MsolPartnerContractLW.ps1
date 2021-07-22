Function global:Get-MsolPartnerContractLW {
    param(
        [string]$DomainName,
        [string]$SearchKey,
        [string]$SearchString,
        [int]$MaxResults,
        [string]$TenantID,
        [switch]$All
    )

    if ($DomainName){
        $DomainVal = "<c:DomainName>$DomainName</c:DomainName>"
    } else {
        $DomainVal = '<c:DomainName i:nil="true" />'
    }

    if ($SearchKey){
        $SearchKeyVal = "<c:SearchKey>$SearchKey</c:SearchKey>"
    } else {
        $SearchKeyVal = '<c:SearchKey>DisplayName</c:SearchKey>'
    }

    if ($SearchString){
        $SearchStringVal = "<c:SearchString>$SearchString</c:SearchString>"
    } else {
       $SearchStringVal = '<c:SearchString i:nil="true" />'
    }

    if ($MaxResults){
        $MaxResultsVal = "<c:PageSize>$MaxResults</c:PageSize>"
    } else {
        $MaxResultsVal = "<c:PageSize>500</c:PageSize>"
    }

    if ($TenantID){
        $TenantIDVal = "<b:TenantId>$TenantID</b:TenantId>"
    } else {
        $TenantIDVal = '<b:TenantId i:nil="true" />'
    }

    if ($All){
        $MaxResultsVal = "<c:PageSize>500</c:PageSize>"
    }

    $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/ListPartnerContracts"
    $Body = @"
<ListPartnerContracts xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$TenantIDVal<b:VerifiedDomain i:nil="true"/><b:PartnerContractSearchDefinition xmlns:c="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration">$($MaxResultsVal)$($SearchStringVal)<c:SortDirection>Ascending</c:SortDirection><c:SortField>None</c:SortField><c:ContractType i:nil="true"/>$($DomainVal)<c:ManagedTenantId i:nil="true"/>$($SearchKeyVal)</b:PartnerContractSearchDefinition></request></ListPartnerContracts>
"@

    $XML = Invoke-MSOnlineRequest -Action $Action -Body $Body

    $Contracts = foreach ($contract in $XML.Envelope.Body.ListPartnerContractsResponse.ListPartnerContractsResult.ReturnValue.Results.PartnerContract) {
        [PSCustomObject]@{
            ContractType      = $contract.ContractType
            DefaultDomainName = $contract.DefaultDomainName
            Name              = $contract.Name
            ObjectId          = $contract.ObjectId
            PartnerContext    = $contract.PartnerContext
            TenantId          = $contract.TenantId
        }
    }

    Return $Contracts

}