<#
.SYNOPSIS
    Increasingly adds number to each file's name in target directory 

.DESCRIPTION
    When called on folder of files, it adds number to fron of every file's name
    in order in which are files in directory target directory ordered (by Name)
    E.g. when called on folder with files: a.txt, b.txt, c.txt .. z.txt, it 
    renames it to 01_a.txt, 02_b.txt, 03_c.txt .. 26_z.txt.
    Automatically calculates the number of required leading zeros.

.PARAMETER targetDirectory
    First argument is target directory in which files should be renamed

.EXAMPLE
    .\PrependNumberToFiles.ps1 "C:\temp"

.NOTES
    Author: Daniel Dusek
    Date: June 15, 2017
#>

# Obtain parameters 
$targetDir = $args[0]
$totalFiles = (Get-ChildItem $targetDir | Measure-Object).Count;

function PrependNumbersToFiles
{
    function stringLength([string]$string)
    {
        $length = $string | Measure-Object -character | select -expandProperty characters;
        return ($length -as [int]);
    }

    function generateFileNumber([int] $i)
    { 
        $totalCiphers = stringLength($totalFiles);
        $currentCiphers = stringLength($i);
        $leadingZeros = $totalCiphers-$currentCiphers;

        $fileNumber = "0" * $leadingZeros;
        $fileNumber = "$($fileNumber)$i"

        return $fileNumber;
    }


    # Iterate over directory contents and rename files
    $i = 1;
    Get-ChildItem $targetDir |
    Foreach-Object{
        $originalName = $_.Name
        $originalFullNamePath = $_.FullName

        $fileNumber = generateFileNumber($i);
        $newName = "$($fileNumber)_$($originalName)";

        Write-Host "Renaming $originalName to $newName  (in $originalFullNamePath)";
        Rename-Item $originalFullNamePath $newName

        $i = ($i+1);
    }
}
PrependNumbersToFiles

# TODO: Could use extension in form of enforcing file renaming (loop until file CAN be renamed)
# TODO: Could check whether there are only files in the directory 
# TODO: Could check whether the parameter given was actually a directory