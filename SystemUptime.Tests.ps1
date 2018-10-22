#This is a script to test that the SystemUptime Script is still functioning as intended.

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

#write some test

Describe "Uptime Tests"{
    it "Test to see if Get-Ciminstance is returning values"{
        Get-CimInstance -ComputerName $ComputerName -ClassName win32_operatingsystem | Select-Object csname, lastbootuptime | should -be -not $null
    }
    it "Pass test values to Get-CimInstance and see if logic is correct"{
        Mock Get-CimInstance {
            return @{
                csname = "localhost"
                lastbootuptime = (get-date).AddDays(-1)
            }
        } -Verifiable
        Mock New-TimeSpan {
            return @{
                Days = 1
                Hours = 0
                Minutes = 0
            }
        } -Verifiable

        $updateTest = Get-Uptime
        $updateTest.Days | should -be 1
        $updateTest.Hours | Should -Be 0
        $updateTest.Minutes | Should -Be 0

    }
}
