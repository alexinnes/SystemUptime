﻿function Get-Uptime {
     <#
    .Synopsis
       gets the computers uptime in Days, Hours and Minutes
    .DESCRIPTION
       gets the computers uptime in Days, Hours and Minutes
    .EXAMPLE
       Get-Uptime -Computername <ComputerName>
    .EXAMPLE
       Get-Uptime #Gets the uptime of the local computer.
    .INPUTS
       -ComputerName Specify the name of the computer you want to check
    #>
    [CmdletBinding()]
    Param (

        # Specify the name of one or more computers
        [Parameter(
            Position = 0,
            Mandatory = $false,
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true,
            ParameterSetName = 'Computer'
        )]
        [Alias("Computer", "__SERVER", "IPAddress")]
        $ComputerName = $env:COMPUTERNAME

    )

    Begin {
        $LastReboot = Get-CimInstance -ComputerName $ComputerName -ClassName win32_operatingsystem

    }

    Process {
        $TimeSpan = New-TimeSpan -start $LastReboot.lastbootuptime -end (get-date)
        $output = [ordered]@{
            Days = $timeSpan.Days
            Hours = $timeSpan.Hours
            Minutes = $timeSpan.Minutes
            ServerName = $ComputerName
        }
    }

    End {
        return $output
    }
}
