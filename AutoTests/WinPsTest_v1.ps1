function Unmove-Item([bool]$Confirm, [string]$filter = "*.*")
{
    Get-ChildItem '\TestData\Test' -Filter $filter | Move-Item -Destination \TestData\Working\ -Force:$Confirm
}

function Unmove-ItemMain([bool]$Confirm, [string]$filter = "*.*")
{
    Get-ChildItem '\ProgramData\Test' -Filter $filter | Move-Item -Destination \ProgramData\Working\ -Force:$Confirm
}

function Compare-TestResults([string]$Filter, [string[]]$Compared, [bool] $Recurse, [bool]$Confirm)
{
    [string[]]    $itemsInMoved = Get-ChildItem \TestData\Working\* -Include $filter -Name -Recurse:$Recurse |Sort-Object
        Get-ChildItem \TestData\Working\* -Include $filter -Recurse:$Recurse | Move-Item -Destination 'TestData\Test' -Force:$Confirm
    
    if(@(Compare-Object $itemsInMoved ($compared | Sort-Object) -SyncWindow 0).Length -eq 0)
    {
        "OK";
    }
    else
    {
        "Failed"
    }
}


[string] $filt = "*.jpg"
[string] $split = '.\SplitTool\source\splitool.dart'
[string[]] $res = $null


Set-Location E:\

dart $split -h

dart $split -t 'ProgramData\Working' -r -f $filt --dry-run
 
$res  = dart $split -t 'ProgramData\Working' -d 'ProgramData\Test' -f $filt -s
Compare-TestResults -filter $filt -compared $res -recurse $false -Confirm:$true 

$res  = dart $split -t 'ProgramData\Working' -d 'ProgramData\Test' -r -f $filt
Compare-TestResults -filter $filt -compared $res -recurse $true -Confirm:$true
Unmove-Item -Confirm:$true
Unmove-ItemMain -Confirm:$true

$filt = "G*.*"

$res  = dart $split -t 'ProgramData\Working' -d 'ProgramData\Test' -r -f $filt
Compare-TestResults -filter $filt -compared $res -recurse $true
Unmove-Item
Unmove-ItemMain