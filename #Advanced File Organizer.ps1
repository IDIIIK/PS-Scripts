#Advanced File Organizer
$FilePath = Read-Host -prompt "Give File Path NOW!!!"
$Drive = "C:\"
$FullPath = $Drive + $FilePath
$LogDir = "C:\Logs"
$LogFileName = "YourLogFile.txt"
$LogPath = Join-Path -Path $LogDir -ChildPath $LogFileName

#Check and Create the log directory if it doesn't exist
if(-not (Test-Path -Path $LogDir -PathType Container)){
    New-Item -Path $LogDir -ItemType Directory
}

#Function to append a message to the log file
function Write-Log {
    param ([string]$message)
    try {
     $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
  "$Timestamp : $message" | Out-File -FilePath $LogPath -Append
    } catch {
        Write-Host "An error occured while writing to the log: $_"
    }
  
}

#Find the extension for the different objects and trims out what we dont need
Get-ChildItem -Path $FullPath -File | ForEach-Object {
    try {
    $extension = $_.Extension
    if(-not [String]::IsNullOrWhiteSpace($extension)) {
$dirName = $extension.TrimStart('.')
$targetDir = Join-Path -Path $FullPath -ChildPath $dirName

if(-not (Test-Path -Path $targetDir -PathType Container)) {
    New-Item -Path $targetDir -ItemType Directory
    Write-Log "Created Directory: $targetDir"
        }

        #Construct Target Path With File Name
    $targetPath = Join-Path -Path $targetDir -ChildPath $_.Name

    #Move The File to the Target Directory
    Move-Item -path $_.FullName -Destination $targetPath
    Write-Log "Moved file: $($_.FullName) to $targetDir"
         }
     } Catch {Write-Log "Error Moving file $($_.Name)_"
    }
}


