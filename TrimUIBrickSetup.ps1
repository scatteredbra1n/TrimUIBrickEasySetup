# Prompt the user for the SD card drive letter
$sdCardDrive = Read-Host "Enter the drive letter of your SD card (e.g., D:)"

# Validate the input
if (-not (Test-Path "$sdCardDrive\")) {
    Write-Host "The drive $sdCardDrive does not exist. Please check and try again." -ForegroundColor Red
    exit
}

# URL of the ZIP file
$url = "https://github.com/trimui/assets_brick/releases/download/20241105/tg3040_Brick_SD_base_package_20241105.zip"

# Temporary file path for the downloaded ZIP
$tempZip = "$env:Temp\contents.zip"

# Destination folder (root of the SD card)
$destinationFolder = "$sdCardDrive\"

# Path to 7-Zip executable
$sevenZipPath = "C:\Program Files\7-Zip\7z.exe"

# Check if 7-Zip exists
if (-not (Test-Path $sevenZipPath)) {
    Write-Host "7-Zip executable not found at $sevenZipPath. Please install 7-Zip or update the script with the correct path." -ForegroundColor Red
    exit
}

# Function to download file with progress bar
Function Download-WithProgress {
    param (
        [string]$SourceUrl,
        [string]$DestinationPath
    )

    # Initialize variables for progress tracking
    $response = Invoke-WebRequest -Uri $SourceUrl -Method Head
    $totalBytes = [int64]$response.Headers["Content-Length"]
    $bytesDownloaded = 0
    $bufferSize = 8192

    # Create file stream
    $fileStream = [System.IO.File]::Create($DestinationPath)
    $webRequest = [System.Net.HttpWebRequest]::Create($SourceUrl)
    $webRequest.Method = "GET"

    # Get the response stream
    $responseStream = $webRequest.GetResponse().GetResponseStream()
    $buffer = New-Object byte[] $bufferSize

    Write-Host "Downloading file..."
    while (($readBytes = $responseStream.Read($buffer, 0, $bufferSize)) -gt 0) {
        $fileStream.Write($buffer, 0, $readBytes)
        $bytesDownloaded += $readBytes

        # Calculate and display progress
        $percentComplete = [math]::Round(($bytesDownloaded / $totalBytes) * 100, 2)
        Write-Progress -Activity "Downloading File" -Status "$percentComplete% complete" -PercentComplete $percentComplete
    }

    # Close streams
    $fileStream.Close()
    $responseStream.Close()
    Write-Host "Download complete."
}

# Download the ZIP file with progress bar
Download-WithProgress -SourceUrl $url -DestinationPath $tempZip

# Extract the ZIP file using 7-Zip
Write-Host "Extracting contents to $destinationFolder using 7-Zip..."
Start-Process -NoNewWindow -Wait -FilePath $sevenZipPath -ArgumentList "x `"$tempZip`" -o`"$destinationFolder`" -y"
Write-Host "Extraction complete."

# Clean up the temporary ZIP file
Remove-Item $tempZip -Force
Write-Host "Temporary file removed."

Write-Host "Operation completed successfully. The contents have been extracted to $destinationFolder" -ForegroundColor Green
