function Unmove-Item([bool]$Confirm, [string]$Filter = "*.*", [string]$Target, [string]$Destination)
{
    Get-ChildItem $Target -Filter $Filter | Move-Item -Destination $Destination -Force:$Confirm
}

function Unmove-ItemMain([bool]$Confirm, [string]$Filter = "*.*", [string]$Target, [string]$Destination)
{
    Get-ChildItem $Target -Filter $Filter | Move-Item -Destination $Destination -Force:$Confirm
}

function Compare-TestResults([string]$Filter, [string[]]$Compared, [bool] $Recurse, [bool]$Confirm, [string]$Target, [string]$Destination)
{
    [string[]]$itemsInMoved = Get-ChildItem $Target -Include $filter -Recurse:$Recurse  -Name |Sort-Object
    Get-ChildItem $Target -Include $filter -Recurse:$Recurse | Move-Item -Destination $Destination -Force:$Confirm
    
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
[string] $target = 'ProgramData\Working'
[string] $destination = 'ProgramData\Test'
[string] $targetTest = 'TestData\Working'
[string] $destinationTest = 'TestData\Test'
[string[]] $res = $null


Set-Location E:\

dart $split -h

dart $split -t $target -r -f $filt --dry-run
 
$res  = dart $split -t $target -d $destination -f $filt -s
Compare-TestResults -filter $filt -compared $res -recurse $false -Confirm:$true -Target $targetTest -Destination $destinationTest

#it is meant that you maust have some files in nested folders, in my case it was one file in Folder 'Ins'
$res  = dart $split -t $target -d $destination -f $filt -r
Compare-TestResults -filter $filt -compared $res -recurse  $true -Confirm:$true -Target $targetTest -Destination $destinationTest
Unmove-Item -Confirm:$true -Target $targetTest -Destination $destinationTest
Unmove-ItemMain -Confirm:$true -Target $target -Destination $destination

$filt = "G*.*"

$res  = dart $split -t $target -r -f $filt
Compare-TestResults -filter $filt -compared $res -recurse $true -Target $targetTest -Destination $destinationTest
Unmove-Item -Target $targetTest -Destination $destinationTest
Unmove-ItemMain -Target $target -Destination $destination