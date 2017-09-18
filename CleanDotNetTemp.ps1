<#
.SYNOPSIS
    Annihilates contents of .NET temp files

.DESCRIPTION
    Removes all the files from .NET temporary folder while leaving the folder
    itself intact. Deleting "Temporary ASP.NET Files" is not advised.

.EXAMPLE
    ./CleanDotNetTemp.ps1

.NOTES
    Author: Daniel Dusek
    Date: September 10, 2015
#>

function Wipe-IISFolder($folderName)
{
    if (!$folderName)
    {
        Write-Host "Folder name to be wiped has to be specified."
        return;
    }

    $i = 0
    while($True)
    {
        iisreset /stop
        
        $Items = @(Get-ChildItem $folderName)
        if (($Items.Length -eq 0) -or ($i -eq 5))
        {
            break;
        } 
        else
        {
            Get-ChildItem -Path $folderName | Remove-Item -Force -Recurse -EA "SilentlyContinue"

            if ($i -ne 0)
            {
                Write-Host "Retrying... #$($i)"
                Start-Sleep -s 10
            }
        }

        iisreset /start
        $i += 1
    }

    return $True
}

$TempDotNetFolder="C:\Windows\Microsoft.NET\Framework64\v4.0.30319\Temporary ASP.NET Files"
Write-Host "Annihilating .NET temp files in: $TempDotNetFolder"
Wipe-IISFolder $TempDotNetFolder