<#
.SYNOPSIS
    Locks file for specified amount of time so it can not be removed.

.DESCRIPTION
    Opens a dummy stream reader over the file, so when other processes try to
    remove the file, it will not let them.

.PARAMETER FileName
    Path to a file to be locked.

.PARAMETER Duration
    Duration in seconds for which the file should be locked. If 0 is given, 
    file will be locked for as long as powershell session exists. 

.EXAMPLE
    Lock-File "C:\myfile.txt" 10 
    - Locks the file 'C:\myfile.txt' for 10 seconds
    Lock-File "C:-\myfile.txt" 0
    - Locks the file 'C:\myfile.txt' for as long as powershell session exists

.NOTES
    Author: Daniel Dusek
    Date: August 17, 2017
    
    Possible TODO: Allow for file to be deleted when Lock-File functions is 
    interrupted by CTRL-C signal. I did not implement this since in Powershell
    I would have to poll for user pressing CTRl-C to detect it, which is the 
    only possible solution for this problem and I, personally, do not like it.
#>

Param (
    [Parameter(Mandatory=$True)] [string] $FileName,
    [Parameter(Mandatory=$True)] [int] $Duration
)

function Lock-File
{

    $StreamReader = New-Object System.IO.StreamReader(Get-Item -Path $FileName)
    if ($Duration -ne 0)
    {
        Start-Sleep -s $Duration
        $StreamReader.Close()
    }
    else 
    {
        while ($True)
        {
            Start-Sleep -s 1
        }   
    }
}
Lock-File