$Public  = @(Get-ChildItem -Path $PSScriptRoot\Public\*.ps1 -ErrorAction SilentlyContinue) + @(Get-ChildItem -Path $PSScriptRoot\Private\*.ps1 -ErrorAction SilentlyContinue)
foreach ($import in @($Public))
{
    try
    {
        . $import.FullName
    }
    catch
    {
        Write-Error -Message "Failed to import function $($import.FullName): $_"
    }
    
}

Set-Alias -Name Connect-MsolService -Value Connect-MsolServiceLW -Scope Global
Set-Alias -Name Get-MsolUser -Value Get-MsolUserLW -Scope Global
Set-Alias -Name Get-MsolPartnerContract -Value Get-MsolPartnerContractLW -Scope Global
Set-Alias -Name Get-MsolDomain -Value Get-MsolDomainLW -Scope Global
