# Install OhMyPosh from module PowerShellGet

Install-Module –Name PowerShellGet –Force
Install-Module posh-git -Scope CurrentUser -Force
Install-Module oh-my-posh -Scope CurrentUser -Force

# Install Powerline Fonts

git clone "https://github.com/powerline/fonts.git"
cd .\fonts
.\install.ps1 furamono-*, hack-*

# Create profile script

if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }

# Add to profile

Add-Content $PROFILE "`nImport-Module posh-git"
Add-Content $PROFILE "`nImport-Module oh-my-posh"
Add-Content $PROFILE "`nSet-Theme agnoster"

