Configuration PowerShellDSC
{

    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
	Import-DscResource -ModuleName 'cChoco'

        cChocoInstaller installChoco
        {
            InstallDir = 'C:\choco'
        }

        cChocoPackageInstaller pwsh
        {
            Name      = 'pwsh'
            DependsOn = '[cChocoInstaller]installChoco'
        }

Script Initialize_Disk
    {
        SetScript =
        {
            # Start logging the actions 
            Start-Transcript -Path C:\Temp\Diskinitlog.txt -Append -Force
 
            # Move CD-ROM drive to Z:
            "Moving CD-ROM drive to Z:.."
            ## Get-WmiObject -Class Win32_volume -Filter 'DriveType=5' | Select-Object -First 1 | Set-WmiInstance -Arguments @{DriveLetter='Z:'}
            # Set the parameters 
            $disks = Get-Disk | Where-Object partitionstyle -eq 'raw' | Sort-Object number
            ## $letters = 69..89 | ForEach-Object { [char]$_ }
            $letters = 70..89 | ForEach-Object { [char]$_ }
            $count = 0
            $label = "Data"
 
            "Formatting disks.."
            foreach ($disk in $disks) {
            $driveLetter = $letters[$count].ToString()
           $disk |
            Initialize-Disk -PartitionStyle MBR -PassThru |
            New-Partition -UseMaximumSize -DriveLetter $driveLetter |
            Format-Volume -FileSystem NTFS -NewFileSystemLabel "$label.$count" -Confirm:$false -Force
            "$label.$count"
            $count++
        }
                                                            
 
            
 
                Stop-Transcript
        }
 
 
        
    TestScript =
    {
            try 
                {
                    Write-Verbose "Testing if any Raw disks are left"
                    # $Validate = New-Object -ComObject 'AgentConfigManager.MgmtSvcCfg' -ErrorAction SilentlyContinue
                    $Validate = Get-Disk | Where-Object partitionstyle -eq 'raw'
                }
                catch 
                {
                    $ErrorMessage = $_.Exception.Message
                    $ErrorMessage
                }
 
            If (!($Validate -eq $null)) 
            {
                   Write-Verbose "Disks are not initialized"     
                    return $False 
            }
                Else
            {
                    Write-Verbose "Disks are initialized"
                    Return $True
                
            }
    }
 
 
        GetScript = { @{ Result = Get-Disk | Where-Object partitionstyle -eq 'raw' } }
                
    }
    
    Log AfterScriptInitializeDisk
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the Script Initialize_Disk resource"
            DependsOn = "[Script]Initialize_Disk" 
        } 

    File root {
            Type = 'Directory'
            DestinationPath = 'F:\Hold'
            Ensure = "Present"
            DependsOn = '[Script]Initialize_Disk'
        } 

    Log AfterFileroot
        {
            # The message below gets written to the Microsoft-Windows-Desired State Configuration/Analytic log
            Message = "Finished running the File root resource"
            DependsOn = "[File]root" 
        } 


}