# Variables for common values
$resourceGroup = "myAzureRsGroup"
$location = "westeurope"
$vmName = "dev-001"

<#
get-help AzureRmVMSourceImage

$PublisherName = "MicrosoftWindowsServer"
$Offer = "WindowsServer"

$sku = "2016-Datacenter"
"VS-2017-Ent-Win10-N"
VS-2015-Ent-VSU3-AzureSDK-29-Win10-N
#>
$PublisherName = "MicrosoftVisualStudio"
$Offer = "VisualStudio"
$sku = "VS-2017-Ent-WS2016"

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

("Start creation process... UserName:{0}" -f $cred.UserName)

# Create a resource group
New-AzureRmResourceGroup -Name $resourceGroup -Location $location

# Create a subnet configuration
$subnetConfig = New-AzureRmVirtualNetworkSubnetConfig -Name mySubnet -AddressPrefix 192.168.1.0/24

# Create a virtual network
$vnet = New-AzureRmVirtualNetwork -ResourceGroupName $resourceGroup -Location $location `
  -Name MYvNET -AddressPrefix 192.168.0.0/16 -Subnet $subnetConfig

"Create a public IP address and specify a DNS name.."
$pip = New-AzureRmPublicIpAddress -ResourceGroupName $resourceGroup -Location $location `
  -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4
("{0}" -f $pip.Name)

# Create an inbound network security group rule for port 3389
$nsgRuleRDP = New-AzureRmNetworkSecurityRuleConfig -Name myNetworkSecurityGroupRuleRDP  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 3389 -Access Allow

# Create a network security group
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $resourceGroup -Location $location `
  -Name myNetworkSecurityGroup -SecurityRules $nsgRuleRDP

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzureRmNetworkInterface -Name myNic -ResourceGroupName $resourceGroup -Location $location `
  -SubnetId $vnet.Subnets[0].Id -PublicIpAddressId $pip.Id -NetworkSecurityGroupId $nsg.Id

"Create a virtual machine configuration..."
# Standard_D1
$vmConfig = New-AzureRmVMConfig -VMName $vmName -VMSize Standard_D1 | `
Set-AzureRmVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzureRmVMSourceImage -PublisherName $PublisherName -Offer $offer -Skus $sku -Version latest | `
Add-AzureRmVMNetworkInterface -Id $nic.Id

"Create a virtual machine..."
New-AzureRmVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig -verbose
("Done you can log on to {0} with {1}!" -f $vmName, $cred.UserName)

#Remove-AzureRmResourceGroup -Name $resourceGroup