Function global:Get-MsolUserLW {
    param (
        [string]$TenantID,
        [switch]$ReturnDeletedUsers,
        [string]$City,
        [string]$Country,
        [string]$Department,
        [string]$DomainName,
        [ValidateSet("EnabledOnly", "DisabledOnly")]
        [string]$EnabledFilter,
        [string]$State,
        [switch]$Synchronized,
        [string]$Title,
        [switch]$HasErrorsOnly,
        [switch]$LicenseReconciliationNeededOnly,
        [switch]$UnlicensedUsersOnly,
        [string]$UsageLocation,
        [string]$SearchString,
        [Int32]$MaxResults,
        [switch]$All,
        [string]$ObjectId,
        [string]$UserPrincipalName

    )
    $DataBlob = $script:MSOnlineLWSession.envelope.header.BecContext.DataBlob.'#text'
    $MessageTracker = New-Guid

    if ($TenantID) {
        $TenantSearch = "<b:TenantId>$TenantID</b:TenantId>"
    }
    else {
        $TenantSearch = "<b:TenantId i:nil=`"true`" />"
    }

    if ($ReturnDeletedUsers) {
        $ReturnDeletedUsersSearch = "<c:ReturnDeletedUsers>true</c:ReturnDeletedUsers>"
    }
    else {
        $ReturnDeletedUsersSearch = "<c:ReturnDeletedUsers i:nil=`"true`" />"
    }

    if ($City) {
        $CitySearch = "<c:City>$City</c:City>"
    }
    else {
        $CitySearch = '<c:City i:nil="true" />'
    }

    if ($Country) {
        $CountrySearch = "<c:Country>$Country</c:Country>"
    }
    else {
        $CountrySearch = '<c:Country i:nil="true" />'
    }

    if ($Department) {
        $DepartmentSearch = "<c:Department>$Department</c:Department>"
    }
    else {
        $DepartmentSearch = '<c:Department i:nil="true" />'
    }

    if ($DomainName) {
        $DomainNameSearch = "<c:DomainName>$DomainName</c:DomainName>"
    }
    else {
        $DomainNameSearch = '<c:DomainName i:nil="true" />'
    }

    if ($EnabledFilter) {
        $EnabledFilterSearch = "<c:EnabledFilter>$EnabledFilter</c:EnabledFilter>"
    }
    else {
        $EnabledFilterSearch = '<c:EnabledFilter i:nil="true" />'
    }

    if ($State) {
        $StateSearch = "<c:State>$State</c:State>"
    }
    else {
        $StateSearch = '<c:State i:nil="true" />'
    }

    if ($Synchronized) {
        $SynchronizedSearch = "<c:Synchronized>true</c:Synchronized>"
    }
    else {
        $SynchronizedSearch = '<c:Synchronized i:nil="true" />'
    }

    if ($Title) {
        $TitleSearch = "<c:Title>$Title</c:Title>"
    }
    else {
        $TitleSearch = '<c:Title i:nil="true" />'
    }

    if ($HasErrorsOnly) {
        $HasErrorsOnlySearch = "<c:HasErrorsOnly>true</c:HasErrorsOnly>"
    }
    else {
        $HasErrorsOnlySearch = '<c:HasErrorsOnly i:nil="true" />'
    }

    if ($LicenseReconciliationNeededOnly) {
        $LicenseReconciliationNeededOnlySearch = "<c:LicenseReconciliationNeededOnly>true</c:LicenseReconciliationNeededOnly>"
    }
    else {
        $LicenseReconciliationNeededOnlySearch = '<c:LicenseReconciliationNeededOnly i:nil="true" />'
    }

    if ($UnlicensedUsersOnly) {
        $UnlicensedUsersOnlySearch = "<c:UnlicensedUsersOnly>true</c:UnlicensedUsersOnly>"
    }
    else {
        $UnlicensedUsersOnlySearch = '<c:UnlicensedUsersOnly i:nil="true" />'
    }

    if ($UsageLocation) {
        $UsageLocationSearch = "<c:UsageLocation>$UsageLocation</c:UsageLocation>"
    }
    else {
        $UsageLocationSearch = '<c:UsageLocation i:nil="true" />'
    }

    if ($SearchString) {
        $SearchStringSearch = "<c:SearchString>$SearchString</c:SearchString>"
    }
    else {
        $SearchStringSearch = '<c:SearchString i:nil="true" />'
    }

    if ($MaxResults) {
        $MaxResultsSearch = "<c:PageSize>$MaxResults</c:PageSize>"
    }
    else {
        $MaxResultsSearch = '<c:PageSize>500</c:PageSize>'
    }

    if ($All) {
        $MaxResultsSearch = "<c:PageSize>500</c:PageSize>"
        $AllSearch = ""
    }

    $Body = @"
<ListUsers xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$TenantSearch<b:VerifiedDomain i:nil="true"/><b:UserSearchDefinition xmlns:c="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration">$($MaxResultsSearch)$($SearchStringSearch)<c:SortDirection>Ascending</c:SortDirection><c:SortField>None</c:SortField><c:AccountSku i:nil="true"/><c:BlackberryUsersOnly i:nil="true"/>$($CitySearch)$($CountrySearch)$($DepartmentSearch)$($DomainNameSearch)$($EnabledFilterSearch)$($HasErrorsOnlySearch)<c:IncludedProperties i:nil="true" xmlns:d="http://schemas.microsoft.com/2003/10/Serialization/Arrays"/><c:IndirectLicenseFilter i:nil="true"/>$($LicenseReconciliationNeededOnlySearch)$($ReturnDeletedUsersSearch)$($StateSearch)$($SynchronizedSearch)$($TitleSearch)$($UnlicensedUsersOnlySearch)$($UsageLocationSearch)</b:UserSearchDefinition></request></ListUsers>
"@

    $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/ListUsers"

    if($ObjectID -or $UserPrincipalName){
        if ($ReturnDeletedUsers){
        $ReturnDeletedUsersSearch = "<b:ReturnDeletedUsers>true</b:ReturnDeletedUsers>"
        } else {
            $ReturnDeletedUsersSearch = "<b:ReturnDeletedUsers>false</b:ReturnDeletedUsers>"
        }
    }

    if ($ObjectId) {
        $Body = @"
<GetUser xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$TenantSearch<b:VerifiedDomain i:nil="true"/><b:ObjectId>$ObjectID</b:ObjectId>$ReturnDeletedUsersSearch</request></GetUser>
"@
        $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/GetUser"
    }

    if ($UserPrincipalName) {
        $Body = @"
<GetUserByUpn xmlns="http://provisioning.microsoftonline.com/"><request xmlns:b="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><b:BecVersion>Version16</b:BecVersion>$TenantSearch<b:VerifiedDomain i:nil="true"/>$ReturnDeletedUsersSearch<b:UserPrincipalName>$UserPrincipalName</b:UserPrincipalName></request></GetUserByUpn>
"@
    $Action = "http://provisioning.microsoftonline.com/IProvisioningWebService/GetUserByUpn"
    }

    $Post = @"
<s:Envelope xmlns:s="http://www.w3.org/2003/05/soap-envelope" xmlns:a="http://www.w3.org/2005/08/addressing"><s:Header><a:Action s:mustUnderstand="1">$Action</a:Action><a:MessageID>urn:uuid:$MessageTracker</a:MessageID><a:ReplyTo><a:Address>http://www.w3.org/2005/08/addressing/anonymous</a:Address></a:ReplyTo><UserIdentityHeader xmlns="http://provisioning.microsoftonline.com/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><BearerToken xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">Bearer $($script:MSOnlineLWAdGraphAccessToken)</BearerToken><LiveToken i:nil="true" xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService"/></UserIdentityHeader><BecContext xmlns="http://becwebservice.microsoftonline.com/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><DataBlob xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">$DataBlob</DataBlob><PartitionId xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">94</PartitionId></BecContext><ClientVersionHeader xmlns="http://provisioning.microsoftonline.com/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><ClientId xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">50afce61-c917-435b-8c6d-60aa5a8b8aa7</ClientId><Version xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">1.2.183.57</Version></ClientVersionHeader><ContractVersionHeader xmlns="http://becwebservice.microsoftonline.com/" xmlns:i="http://www.w3.org/2001/XMLSchema-instance"><BecVersion xmlns="http://schemas.datacontract.org/2004/07/Microsoft.Online.Administration.WebService">Version47</BecVersion></ContractVersionHeader><TrackingHeader xmlns="http://becwebservice.microsoftonline.com/">$($script:MSOnlineLWTrackingHeader)</TrackingHeader><a:To s:mustUnderstand="1">https://provisioningapi.microsoftonline.com/provisioningwebservice.svc</a:To></s:Header><s:Body>$Body</s:Body></s:Envelope>
"@	
    $Result = Invoke-WebRequest -method POST -uri "https://provisioningapi.microsoftonline.com/provisioningwebservice.svc" -contenttype "application/soap+xml; charset=utf-8" -body $Post
    [XML]$XML = $Result.content


    if ($UserPrincipalName){
        $Users = $XML.Envelope.Body.GetUserByUpnResponse.GetUserByUpnResult.ReturnValue
    } else {
        if ($ObjectId){
            $Users = $XML.Envelope.Body.GetUserResponse.GetUserResult.ReturnValue
        } else {
            $Users = $XML.Envelope.Body.ListUsersResponse.ListUsersResult.ReturnValue.Results.User
        }
    }
    

    

    $ReturnUsers = foreach ($User in $Users) {
        
        [PSCustomObject]$LicenseAssignments = foreach ($License in $User.LicenseAssignmentDetails.LicenseAssignmentDetail) {
            [PSCustomObject]@{
                AccountSku  = [PSCustomObject] @{
                    AccountName   = $License.accountsku.AccountName
                    SkuPartNumber = $License.accountsku.SkuPartNumber
                }
                Assignments = [PSCustomObject]@{
                    Error              = $License.Assignments.LicenseAssignment.Error
                    ReferencedObjectId = $License.Assignments.LicenseAssignment.ReferencedObjectID
                    Status             = $License.Assignments.LicenseAssignment.Status

                }
            }
        }
        
        $Licenses = foreach ($License in $User.Licenses.UserLicense) {
            [PSCustomObject]@{
                AccountSku             = [PSCustomObject]@{
                    AccountName   = $License.AccountSku.AccountName
                    SkuPartNumber = $License.AccountSku.SkuPartNumber
                }
                AccountSkuId           = $License.AccountSkuId
                GroupsAssigningLicense = $License.GroupsAssigningLicense.guid
                ServiceStatus          = foreach ($Service in $License.ServiceStatus.ServiceStatus) {
                    [PSCustomObject]@{
                        ProvisioningStatus = $Service.ProvisioningStatus
                        ServicePlan        = [PSCustomObject]@{
                            ServiceName   = $Service.ServicePlan.ServiceName
                            ServicePlanId = $Service.ServicePlan.ServicePlanId
                            ServiceType   = $Service.ServicePlan.ServiceType
                            TargetClass   = $Service.ServicePlan.TargetClass
                        }
                    
                    }
                }
                
            }
        }

        $StrongAuthenticationMethods = foreach ($method in $User.StrongAuthenticationMethods.StrongAuthenticationMethod) {
            [PSCustomObject]@{
                IsDefault  = $method.IsDefault
                MethodType = $method.MethodType
            }
        }

        $StrongAuthenticationPhoneAppDetails = foreach ($AppDetails in $User.StrongAuthenticationPhoneAppDetails.StrongAuthenticationPhoneAppDetail) {
            $AppObject = [pscustomobject]@{
                AuthenticationType = $AppDetails.AuthenticationType
                DeviceName         = $AppDetails.DeviceName
                DeviceTag          = $AppDetails.DeviceTag
                DeviceToken        = $AppDetails.DeviceToken
                NotificationType   = $AppDetails.NotificationType
                OathSecretKey      = $AppDetails.OathSecretKey
                OathTokenTimeDrift = $AppDetails.OathTokenTimeDrift
                PhoneAppVersion    = $AppDetails.PhoneAppVersion
            }        
            $AppObject = Get-NullCleaned -OriginalItem $AppDetails -ObjectToClean $AppObject
            $AppObject
        }
        

        $StrongAuthenticationRequirements = foreach ($Requirement in $User.StrongAuthenticationRequirements.StrongAuthenticationRequirement) {
            $ReqObject = [pscustomobject]@{
                RelyingParty                   = $Requirement.RelyingParty
                RememberDevicesNotIssuedBefore = $Requirement.RememberDevicesNotIssuedBefore
                State                          = $Requirement.State
            }        
            $ReqObject = Get-NullCleaned -OriginalItem $Requirement -ObjectToClean $ReqObject
            $ReqObject
        }
        

        $StrongAuthenticationUserDetails = foreach ($UserDetails in $User.StrongAuthenticationUserDetails) {
            $DetailsObject = [pscustomobject]@{
                AlternativePhoneNumber = $UserDetails.AlternativePhoneNumber
                Email                  = $UserDetails.Email
                OldPin                 = $UserDetails.OldPin
                PhoneNumber            = $UserDetails.PhoneNumber
                Pin                    = $UserDetails.Pin
                VoiceOnlyPhoneNumber   = $UserDetails.VoiceOnlyPhoneNumber
            }        
            $DetailsObject = Get-NullCleaned -OriginalItem $UserDetails -ObjectToClean $DetailsObject
            $DetailsObject
        }

         

        $ReturnUser = [PSCustomObject]@{
            AlternateEmailAddresses                = $User.AlternateEmailAddresses.string
            AlternateMobilePhones                  = $User.AlternateMobilePhones.string
            AlternativeSecurityIds                 = $User.AlternativeSecurityIds.string
            BlockCredential                        = $User.BlockCredential
            City                                   = $User.City
            CloudExchangeRecipientDisplayType      = $User.CloudExchangeRecipientDisplayType
            Country                                = $User.Country
            Department                             = $User.Department
            DirSyncEnabled                         = $User.DirSyncEnabled
            DirSyncProvisioningErrors              = $User.DirSyncProvisioningErrors
            DisplayName                            = $User.DisplayName
            Errors                                 = $User.Errors
            Fax                                    = $User.Fax
            FirstName                              = $User.FirstName
            ImmutableId                            = $User.ImmutableId
            IndirectLicenseErrors                  = $User.IndirectLicenseErrors
            IsBlackberryUser                       = $User.IsBlackberryUser
            IsLicensed                             = $User.IsLicensed
            LastDirSyncTime                        = $User.LastDirSyncTime
            LastName                               = $User.LastName
            LastPasswordChangeTimestamp            = $User.LastPasswordChangeTimestamp
            LicenseAssignmentDetails               = $LicenseAssignments
            LicenseReconciliationNeeded            = $User.LicenseReconciliationNeeded
            Licenses                               = $Licenses
            LiveId                                 = $User.LiveId
            MSExchRecipientTypeDetails             = $User.MSExchRecipientTypeDetails
            MSRtcSipDeploymentLocator              = $User.MSRtcSipDeploymentLocator
            MSRtcSipPrimaryUserAddress             = $User.MSRtcSipPrimaryUserAddress
            MobilePhone                            = $User.MobilePhone
            ObjectId                               = $User.ObjectId
            Office                                 = $User.Office
            OverallProvisioningStatus              = $User.OverallProvisioningStatus
            PasswordNeverExpires                   = $User.PasswordNeverExpires
            PasswordResetNotRequiredDuringActivate = $User.PasswordResetNotRequiredDuringActivate
            PhoneNumber                            = $User.PhoneNumber
            PortalSettings                         = $User.PortalSettings.UXVersion
            PostalCode                             = $User.PostalCode
            PreferredDataLocation                  = $User.PreferredDataLocation
            PreferredLanguage                      = $User.PreferredLanguage
            ProxyAddresses                         = $User.ProxyAddresses.string
            ReleaseTrack                           = $User.ReleaseTrack
            ServiceInformation                     = $User.ServiceInformation.ServiceInformation
            SignInName                             = $User.SignInName
            SoftDeletionTimestamp                  = $User.SoftDeletionTimestamp
            State                                  = $User.State
            StreetAddress                          = $User.StreetAddress
            StrongAuthenticationMethods            = $StrongAuthenticationMethods
            StrongAuthenticationPhoneAppDetails    = $StrongAuthenticationPhoneAppDetails
            StrongAuthenticationProofupTime        = $User.StrongAuthenticationProofupTime
            StrongAuthenticationRequirements       = $StrongAuthenticationRequirements
            StrongAuthenticationUserDetails        = $StrongAuthenticationUserDetails
            StrongPasswordRequired                 = $User.StrongPasswordRequired
            StsRefreshTokensValidFrom              = $User.StsRefreshTokensValidFrom
            Title                                  = $User.Title
            UsageLocation                          = $User.UsageLocation
            UserLandingPageIdentifierForO365Shell  = $User.UserLandingPageIdentifierForO365Shell
            UserPrincipalName                      = $User.UserPrincipalName
            UserThemeIdentifierForO365Shell        = $User.UserThemeIdentifierForO365Shell
            UserType                               = $User.UserType
            ValidationStatus                       = $User.ValidationStatus
            WhenCreated                            = $User.WhenCreated
        }

       
        $ReturnUser = Get-NullCleaned -OriginalItem $user -ObjectToClean $ReturnUser


        if ($ReturnUser.LastDirSyncTime) {
            $ReturnUser.LastDirSyncTime = Get-Date("$($ReturnUser.LastDirSyncTime)")
        }
        if ($ReturnUser.LastPasswordChangeTimestamp) {
            $ReturnUser.LastPasswordChangeTimestamp = Get-Date("$($ReturnUser.LastPasswordChangeTimestamp)")
        }
        if ($ReturnUser.StsRefreshTokensValidFrom) {
            $ReturnUser.StsRefreshTokensValidFrom = Get-Date("$($ReturnUser.StsRefreshTokensValidFrom)")
        }
        if ($ReturnUser.WhenCreated) {
            $ReturnUser.WhenCreated = Get-Date("$($ReturnUser.WhenCreated)")
        }
        if ($ReturnUser.SoftDeletionTimestamp) {
            $ReturnUser.SoftDeletionTimestamp = Get-Date("$($ReturnUser.SoftDeletionTimestamp)")
        }

        $ReturnUser

    }

    
    #return $Result.Envelope.Body.ListUsersResponse.ListUsersResult.ReturnValue.Results.User
    return $ReturnUsers
}