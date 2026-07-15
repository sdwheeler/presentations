

<#
Before execuitng commands from this script to build an Azure Cloud shell VNET, The following
resource providers must be registered in your subscription:
- Microsoft.CloudShell
- Microsoft.ContainerInstances
- Microsoft.Relay

You can learn more about registering resource providers and gathering the required information for your unique environment here:
https://learn.microsoft.com/azure/cloud-shell/vnet/deployment#1-register-resource-providers
#>

# Resource Group
$rg = @{
    Name = "<- Your Value Here ->"
    Location = "<- Your Value Here ->"
}
New-AzResourceGroup @rg

# Virtual Netowrk
$vnet = @{
    name = "<- Your Value Here ->"
    location = "<- Your Value Here ->"
    resourceGroupName = "<- Your Value Here ->"
    addressPrefix = "<- Your Value Here ->"
}
New-AzVirtualNetwork @vnet

# Network template
$subnet = @{
    ResourcegroupName = "<- Your Value Here ->"
    TemplateURI = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/demos/cloud-shell-vnet/azuredeploy.json"
    existingVNETName = "<- Your Value Here ->"
    relayNamespaceName = "<- Your Value Here ->"
    azureContainerInstanceOID = (Get-AzADServicePrincipal -DisplayNameBeginsWith 'Azure Container Instance').id
    containerSubnetName = "container-subnet1"
    containerSubnetAddressPrefix = "<- Your Value Here ->"
    relaySubnetName = "relay-subnet1"
    relaySubnetAddressPrefix = "<- Your Value Here ->"
    storageSubnetName = "storage-subnet1"
    storageSubnetAddressPrefix = "<- Your Value Here ->"
    nsgname = "<- Your Value Here ->"
}
New-AzResourceGroupDeployment @subnet


# Storage

$storage = @{
    ResourcegroupName = "<- Your Value Here ->"
    TemplateURI = "https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/demos/cloud-shell-vnet-storage/azuredeploy.json"
    existingVNETName = "<- Your Value Here ->"
    existingStorageSubnetName = "storage-subnet1"
    existingContainerSubnetName = "container-subnet1"
    storageAccountName = "<- Your Value Here ->"
}
New-AzResourceGroupDeployment @storage

