<#
.SYNOPSIS
    Keeps Kentico instance alive

.DESCRIPTION
    The script itself only access periodically the webstie in 5 second interval. Ends on termination immediately.

.PARAMETER InstanceURL
    URL Address of instance to be kept alive

.PARAMETER Silent
    Specifies whether script should produce anything to stdout or not

.EXAMPLE
    KeepAlive -InstanceURL "http://localhost/" -Silent
    
.NOTES
    Author: Daniel Dusek
    Date: June 14, 2017    
#>

Param (
    [Parameter(Mandatory=$True)]  [string] $InstanceURL,
    [switch] $Silent
    )

function KeepInstanceAlive
{
    function AccessURL()
    {
        $request = [System.Net.WebRequest]::Create($InstanceURL);

        try 
        {
            $result = $request.GetResponse();    
        }
        catch [System.Net.WebException]
        {
            $result = $_.Exception.Response;    
        }
        finally
        {
            $result.Close();
        }

        if (-Not ($Silent.IsPresent))
        {
            Write-Host "Accessing $($InstanceURL)... STATUS: $([int] $result.StatusCode)";
        }
    }

    function PrintSeparator()
    {
            Write-Host "================================================================================="
    }


    $i = 0;
    for ($True)
    {
        if (-Not ($Silent.IsPresent))
        {
            PrintSeparator;
            Write-Host "Iteration $($i):";
        }

        AccessURL($InstanceURL);
        $i += 1;


        if (-Not ($Silent.IsPresent))
        {
            PrintSeparator;
        }

        Start-Sleep -s 5;
    }
}
KeepInstanceAlive
