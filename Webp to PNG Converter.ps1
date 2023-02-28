function dwebpInit {
	
	# Set the GUI
	
	#[console]::WindowWidth=70;
	#[console]::WindowHeight=50;
	[console]::BufferWidth=[console]::WindowWidth
	$Host.UI.RawUI.BackgroundColor = 'Black'
	$Host.UI.RawUI.ForegroundColor = 'White'
	
	# Variables
	
	$url = 'https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-1.3.0-windows-x64.zip'
	$envTemp = $env:TEMP+"\libwebp"
	$envInput = $env:TEMP+"\libwebp\input\"
	$envOutput = $env:TEMP+"\libwebp\output\"
	$outputFile = $env:TEMP+"\libwebp-1.3.0-windows-x64.zip"
	$helpFile = $env:TEMP+"\libwebp\input\Please put .webp files here for conversion.txt"
	$outputFolder = $env:APPDATA+"\libwebp-1.3.0-windows-x64"
	$dwebp = $env:APPDATA+"\libwebp\bin\dwebp.exe"
	$libwebp = $env:APPDATA+"\libwebp"
	$title = "Webp to PNG Converter"
	$downloading = "Downloading libwebp 1.3.0 binary files"
	$extracting = "Extracting libwebp 1.3.0 binary files"
	verifyBinary
}

# Welcome screen with hint and confirmation prompt.

function dwebpWelcomeScreen {
	$host.ui.RawUI.WindowTitle = $title
	verifyTempFolder
	verifyInputFolder
	verifyOutputFolder
	verifyHelpFile
	ii $envInput
	Clear-Host
	Write-Host ""
	Write-Host "         Webp to PNG Converter" -ForegroundColor Cyan
	Write-Host ""
	Write-Host "              By Erassus" -ForegroundColor DarkBlue
	Write-Host ""
	Write-Host "This utility will convert all .webp" -ForegroundColor Yellow
	Write-Host "files inside 'input' folder to .png" -ForegroundColor Yellow
	Write-Host ""
	Read-Host -Prompt "Press any key to continue or CTRL+C to abort"
	dwebpConversion
}

# Function to check if dwebp was already installed.

function verifyBinary {
	if (!(Test-Path $dwebp -PathType Leaf)) {
		verifyDownloaded
		}
	else {
		dwebpWelcomeScreen
	}
}

# Function to check if the file was downloaded before.

function verifyDownloaded {
	if (!(Test-Path $outputFile -PathType Leaf)) {
		dwebpDownload
		}
	else {
		dwebpUnzip
	}
}

# Function to download libwebp

function dwebpDownload {
	$host.ui.RawUI.WindowTitle = $downloading
	Invoke-WebRequest -Uri $url -OutFile $outputFile
	dwebpUnzip
	}

# Function to unzip libwebp

function dwebpUnzip {
	$host.ui.RawUI.WindowTitle = $extracting
	Expand-Archive $outputFile -DestinationPath $env:APPDATA
	Rename-Item $outputFolder -NewName "libwebp"
	dwebpWelcomeScreen
}

# Function to check if the "libwebp" folder exist in %TEMP%, if not, it will create it.

function verifyTempFolder {
    if (!(Test-Path $envTemp)) {
		mkdir $envTemp | out-null
    }
	else {
		Clear-Host
	}
}

# Function to check if the "input" folder exist, if not, it will create it.

function verifyInputFolder {
    if (!(Test-Path $envInput)) {
		mkdir $envInput | out-null
    }
	else {
		Clear-Host
	}
}

# Function to check if the "output" folder exist, if not, it will create it.

function verifyOutputFolder {
    if (!(Test-Path $envOutput)) {
		mkdir $envOutput | out-null
    }
	else {
		Clear-Host
	}
}

# Function to check if the help file exist, if not, it will create it.

function verifyHelpFile {
    if (!(Test-Path $helpFile)) {
		New-Item $helpFile
    }
	else {
		Clear-Host
	}
}

function dwebpConversion {

	Remove-Item $helpFile

	# Process all .webp files inside "input" folder with "dwebp.exe".
	
	$images = Get-ChildItem $envInput
	
	Clear-Host
	
	foreach ($img in $images) {
		$outputName = $envOutput + $img.BaseName + ".png"
		& $dwebp $img.FullName -o $outputName
		}
		
	# Remove .webp files from "input" folder.

	Remove-Item $envInput\*.*
	
	# Open output folder after conversion.
	
	ii $envOutput
	
	#Get-ChildItem $envInput -Filter *.webp -recurse | foreach { Remove-Item -Path $_.FullName }
	
	Write-Host ""
	
	cmd /c 'pause'
}

dwebpInit