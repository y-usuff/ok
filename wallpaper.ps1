$imageUrl = "https://i.ytimg.com/vi/wy9NX1UgyFM/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGGUgWyhOMA8=&rs=AOn4CLCxV_jrH7kN_yNNBudZU-9VCE9mVA"
$imagePath = "$env:USERPROFILE\Pictures\Wallpaper.jpg"
$audioFile = "https://file.io/ykoXgN7B4XQG"
$localAudioPath = "$env:TMP\e.wav"

# Download the image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

# Check if the audio file exists locally, download if not
if (-Not (Test-Path -Path $localAudioPath)) {
    Write-Host "Audio file not found locally. Downloading..."
    Invoke-WebRequest -Uri $audioFile -OutFile $localAudioPath
} else {
    Write-Host "Audio file found locally."
}

# Set the wallpaper
Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public class Wallpaper {
    [DllImport("user32.dll", CharSet = CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@

# Constants for setting wallpaper
$SPI_SETDESKWALLPAPER = 0x0014
$SPIF_UPDATEINIFILE = 0x01
$SPIF_SENDCHANGE = 0x02

Add-Type -AssemblyName System.Windows.Forms
$originalPOS = [System.Windows.Forms.Cursor]::Position.X

while (1) {
    $pauseTime = 3
    if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS) {
        break
    } else {
        $o.SendKeys("{CAPSLOCK}"); Start-Sleep -Seconds $pauseTime
    }
}

# Adjust the volume
$k = [Math]::Ceiling(100 / 2)
$o = New-Object -ComObject WScript.Shell
for ($i = 0; $i -lt $k; $i++) {
    $o.SendKeys([char]175)
}

# Set the wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

# Play the audio file
$PlayWav = New-Object System.Media.SoundPlayer
$PlayWav.SoundLocation = $localAudioPath
$PlayWav.playsync()
