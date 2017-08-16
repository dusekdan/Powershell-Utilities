<#
.SYNOPSIS
    Adds content to the beginning of the file

.DESCRIPTION
    Adds content to the beginning of the file in a same matter as would normal 
    Add-Content function would. 

.PARAMETER Path
    String path to file which content is to be altered.

.PARAMETER Value
    Data to be written to start of the file

.EXAMPLE
    Add-ContentToStart -Path README.md -Value "This line is to be Added to the beginning of the README.md file"

.NOTES
    Author: Daniel Dusek
    Date: August 16. 2017

#>

Param (
    [Parameter(Mandatory=$True)] [string] $Path,
    [Parameter(Mandatory=$True)] [string] $Value
)

function Add-ContentToStart{
    param(
        [string] $Path,
        [string] $Value
    )

    $current = Get-Content $Path
    Set-Content -Path $Path -Value $Value
    Add-Content -Path $Path -Value $current
}

Add-ContentToStart -Path $Path -Value $Value