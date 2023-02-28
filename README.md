# Webp-to-PNG-Converter

![Webp_to_PNG_Converter_vOvAX0bn34](https://user-images.githubusercontent.com/10040043/221978446-ede2b6ec-82d7-4c5b-878e-9593aecc05f5.png)

Webp to PNG Converter

This script will auto-download the necessary dwebp binaries and will use it convert .webp files to .png

.BAT file uses PowerShell Invoke-WebRequest to download the dwebp binaries from Google.

.PS1 file will use native PowerShell instructions to download the dwebp binaries for conversion.

Friendly usage, checks if was already downloaded dwebp binaries.

All binaries will be installed in %APPDATA%\libwebp\

For conversion only, folder input and output will be created in the %TEMP% folder.
