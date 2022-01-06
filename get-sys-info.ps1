

# ---------------------------------
#       Version for IOS PCs
# ---------------------------------

Clear-Host
.\GetKeyAndWriteToFile.vbs # This VB script gets us the Windows Product Key
$computerName = $env:COMPUTERNAME
$serialNumber = (Get-WmiObject win32_bios | Select-Object -expand SerialNumber)
$ethernetMacAddress = Get-NetAdapter *ethernet* | Select-Object -ExpandProperty MacAddress
$productKey = (Get-Content .\temp-key-file.txt | ConvertFrom-StringData).InstalledKey
$oemProductKey = Get-WmiObject SoftwareLicensingService | Select-Object -expand Oa3xOriginalProductKey


Write-Host
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
          .::IO SOLUTIONS SYSTEM INVENTORY::.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'

$computer = New-Object System.Object
$computer | Add-Member -MemberType NoteProperty -Name "ComputerName" -Value $computerName
$computer | Add-Member -MemberType NoteProperty -Name "SerialNumber" -Value $serialNumber
$computer | Add-Member -MemberType NoteProperty -Name "MacAddress" -Value $ethernetMacAddress
$computer | Add-Member -MemberType NoteProperty -Name "ProductKey" -Value $productKey
$computer | Add-Member -MemberType NoteProperty -Name "OEMProductKey" -Value $oemProductKey


if((Get-Content .\inventory.csv | Select-String -Pattern $serialNumber).Count -eq 0) {
$computer | Export-Csv -NoTypeInformation -Append -Path "inventory.csv"
Write-Host "
===========================================================
              Data written to .\inventory.csv                
===========================================================
            Computer Name: $computerName
            Serial Number: $serialNumber
            MAC Address: $ethernetMacAddress
            Product Key: $productKey 
	    OEM Product Key: $oemProductKey
===========================================================
"
}

else {
    $duplicateLineNumber = (Get-Content .\inventory.csv | Select-String -Pattern $serialNumber).LineNumber
    Write-Host "!!Info. was not written to file - Serial Number already exists in file @ line: $duplicateLineNumber"
}

Write-Host
':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
          .::Content in Inventory::.
:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'


Get-Content .\inventory.csv

#  Clean up temp file(s)
Remove-Item .\temp-key-file.txt

#Restore ExecutionPolicy