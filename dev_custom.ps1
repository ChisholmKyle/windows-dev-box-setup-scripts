# Description: Boxstarter Script
# Author: Microsoft
# Custom Dev environment

Disable-UAC

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
executeScript "RemoveDefaultApps.ps1";
executeScript "CommonDevTools.ps1";
executeScript "HyperV.ps1";
executeScript "Docker.ps1";
executeScript "WSL.ps1";
executeScript "Browsers.ps1";

#--- Common Dev Tools ---
choco install -y git --package-parameters="'/GitAndUnixToolsOnPath /WindowsTerminal'"
choco install -y python
choco install -y 7zip.install
choco install -y sysinternals

#--- WSL Tools ---
Ubuntu1804 run apt install python2.7 python-pip -y
Ubuntu1804 run apt install python-numpy python-scipy -y

#--- Web Tools ---
code --install-extension msjsdiag.debugger-for-chrome
code --install-extension msjsdiag.debugger-for-edge

#--- Nodejs Tools ---
choco install -y nodejs-lts # Node.js LTS
choco install -y python2 # Node.js requires Python 2 to build native modules
choco install -y firacode

#--- Dev Tools ---
choco install -y jetbrainstoolbox
choco install -y arduino
choco install -y jdk8
choco install -y gradle
choco install -y miktex
choco install -y cmake --installargs 'ADD_CMAKE_TO_PATH=User'

#-- apps ---
choco install -y sumatrapdf
choco install -y inkscape
choco install -y blender
choco install -y dropbox
choco install -y keepassx
choco install -y vlc
choco install -y conemu
choco install -y vscode
choco install -y sublimetext3

#--- Microsoft Studio ---
choco install -y visualstudio2019community
choco install -y visualstudio2019buildtools
choco install -y visualstudio2019-workload-vctools
choco install -y visualstudio2019-workload-nativedesktop

write-host "Finished installation"

#--- Choco Utility ---
choco install -y choco-cleaner

Enable-UAC
Enable-MicrosoftUpdate
Install-WindowsUpdate -acceptEula
