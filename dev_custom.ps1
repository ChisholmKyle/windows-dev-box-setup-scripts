# Description: Boxstarter Script
# Author: Microsoft
# Custom Dev environment

Disable-UAC
$ConfirmPreference = "None" #ensure installing powershell modules don't prompt on needed dependencies

# Set PC name
$computername = "xps9570"
if ($env:computername -ne $computername) {
    Rename-Computer -NewName $computername
}

# Get the base URI path from the ScriptToCall value
$bstrappackage = "-bootstrapPackage"
$helperUri = $Boxstarter['ScriptToCall']
$strpos = $helperUri.IndexOf($bstrappackage)
$helperUri = $helperUri.Substring($strpos + $bstrappackage.Length)
$helperUri = $helperUri.TrimStart("'", " ")
$helperUri = $helperUri.TrimEnd("'", " ")
$helperUri = $helperUri.Substring(0, $helperUri.LastIndexOf("/"))
$helperUri += "/scripts"
write-host "helper script base URI is $helperUri"

function executeScript {
    Param ([string]$script)
    write-host "executing $helperUri/$script ..."
	iex ((new-object net.webclient).DownloadString("$helperUri/$script"))
}

#--- Setting up Windows ---
executeScript "SystemConfiguration.ps1";
executeScript "FileExplorerSettings.ps1";
executeScript "SystemPrivacy.ps1";
executeScript "TaskbarSettings.ps1";
executeScript "RemoveDefaultApps.ps1";

#--- Git and SSH ---
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
RefreshEnv

# optionally configure git and ssh
# git config --global user.name "FIRST_NAME LAST_NAME"
# git config --global user.email "MY_NAME@example.com"
# ssh-keygen -t rsa -b 4096 -q -N ""

#--- Common Dev Tools ---
choco install -y python2
choco install -y python
choco install -y 7zip.install
choco install -y sysinternals

#--- Hyper-V ---
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
RefreshEnv

#--- WSL ---
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
RefreshEnv

#--- Ubuntu ---
Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile ~/Ubuntu.appx -UseBasicParsing
Add-AppxPackage -Path ~/Ubuntu.appx

#--- Debian ---
Invoke-WebRequest -Uri https://aka.ms/wsl-debian-gnulinux -OutFile ~/debian.appx -UseBasicParsing
Add-AppxPackage -Path ~/debian.appx

#--- Docker ---
Enable-WindowsOptionalFeature -Online -FeatureName containers -All
RefreshEnv
choco install -y docker-desktop

#--- Browsers ---
choco install -y googlechrome
choco install -y firefox

#--- Nodejs ---
choco install -y nodejs-lts # Node.js LTS

#--- Dev Tools ---
choco install -y jetbrainstoolbox
choco install -y arduino
choco install -y jdk8
choco install -y gradle
choco install -y miktex
choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=User'

#-- apps ---
choco install -y sumatrapdf.install
choco install -y inkscape
choco install -y blender
choco install -y dropbox
choco install -y keepassx
choco install -y vlc
choco install -y vscode
choco install -y sublimetext3
choco install -y etcher

#--- Microsoft Studio ---
choco install -y visualstudio2019community
choco install -y visualstudio2019buildtools
choco install -y visualstudio2019-workload-vctools
choco install -y visualstudio2019-workload-nativedesktop

#--- Powershell ---
choco install -y powershell-core
choco install -y conemu
executeScript "OhMyPosh.ps1";

#--- Command aliases ---
Add-Content $PROFILE "`nSet-Alias -Name subl -Value `"C:\Program Files\Sublime Text 3\subl.exe`""
Add-Content $PROFILE "`nSet-Alias -Name which -Value get-command"

#--- vscode extensions ---
choco install -y vscode-docker
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

write-host "Finished installation"

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
