#
# Reference: https://github.com/dotnet/AspNetCore.Docs/issues/16231#issuecomment-566369881
#
# This is a programmatic way to download the Windows Hosting Bundle installer
#

#
# Set path where installer files will be downloaded to, create if it doesn't exist
#

$temp_path = "C:\temp\"

if (-not (Test-Path -Path $temp_path)) {
    New-Item -ItemType Directory -Path $temp_path | Out-Null
    Write-Host "Directory created: $temp_path"
} else {
    Write-Host "Directory already exists: $temp_path"
}


#
# Download and install the Windows Hosting Bundle Installer for ASP.NET Core
# NOTE: installs 6.x. Update the URL for your desired version
#

$whb_installer_url = "https://download.visualstudio.microsoft.com/download/pr/6e855d0c-464a-4ade-b92f-2ba604e68897/cb3b140bdf36b5bc16efc49787028cb8/dotnet-hosting-6.0.19-win.exe"

$whb_installer_file = $temp_path + [System.IO.Path]::GetFileName( $whb_installer_url )

Try
{
    # https://learn.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-windows#using-invoke-webrequest
   Invoke-WebRequest -Uri $whb_installer_url -OutFile $whb_installer_file -UseBasicParsing

   Write-Output ""
   Write-Output "Windows Hosting Bundle Installer downloaded"
   Write-Output "- Execute the $whb_installer_file to install the ASP.Net Core Runtime"
   Write-Output ""

   Start-Process $whb_installer_file -ArgumentList "/install /passive /norestart" -Wait

}
Catch
{

   Write-Output ( $_.Exception.ToString() )

   Break

}

# upload this script to a location that can be accessed by the VM, e.g. a blob container

# invoke the custom script on the VM via Az CLI:

# az vm extension set \
# --publisher Microsoft.Compute \
# --version 1.8 \
# --name CustomScriptExtension \
# --vm-name $VmName \
# --resource-group $ResourceGroupName \
# --settings '{"fileUris":["https://mystorageaccount.blob.core.windows.net/public/install-win-hosting-bundle.ps1"],"commandToExecute":"powershell.exe -ExecutionPolicy Unrestricted -file install-win-hosting-bundle.ps1"}'