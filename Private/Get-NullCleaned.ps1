function Get-NullCleaned{
    param(
        $OriginalItem,
        [PSCustomObject]$ObjectToClean
    )

    $SkipList = @("HasChildNodes","ChildNodes","IsFixedSize","StrongAuthenticationMethods","HasAttributes","IsEmpty","nil")


    $OriginalItem.PSObject.Properties | ForEach-Object {
        if ($_.Name -notin $SkipList) {
            if ($_.value -eq "true") {
                $ObjectToClean."$($_.Name)" = $true  
            }
            if ($_.value -eq "false") {
                $ObjectToClean."$($_.Name)" = $false  
            }
            if ($ObjectToClean."$($_.Name)".nil) {
                $ObjectToClean."$($_.Name)" = $null
            }
        }
    }


   Return $ObjectToClean
    
}


