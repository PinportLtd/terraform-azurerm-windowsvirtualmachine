$filename = -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
get-service | ? {$_.DisplayName -eq "Windows Azure Guest Agent"} | Out-File c:\$filename"service.txt" 