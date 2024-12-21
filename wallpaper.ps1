# shush
$imageUrl = "https://i.ytimg.com/vi/wy9NX1UgyFM/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AH-CYAC0AWKAgwIABABGGUgWyhOMA8=&rs=AOn4CLCxV_jrH7kN_yNNBudZU-9VCE9mVA"
$imagePath = "$env:USERPROFILE\Pictures\Wallpaper.jpg"

# Download the image
Invoke-WebRequest -Uri $imageUrl -OutFile $imagePath

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

# Set the wallpaper
[Wallpaper]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $imagePath, $SPIF_UPDATEINIFILE -bor $SPIF_SENDCHANGE)

Write-Host "Wallpaper has been set successfully!"
