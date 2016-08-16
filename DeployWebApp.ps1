# Sign into Azure

Login-AzureRmAccount
Get-AzureRmSubscription | Select-AzureRmSubscription 


# collect initials for generating unique names

$init = Read-Host -Prompt "Please type your initials in lower case, and then press ENTER."


# Prompt for the Azure region in which to build the lab machines
<# 
Write-Host ""
Write-Host "Where in the world do you want to put these VMs?"
Write-Host "Carefully enter 'East US' or 'West US'"
$loc = Read-Host -Prompt "and then press ENTER."
#>

$loc = "EAST US 2"

# Variables 

$rgName = "RG-WebAppDeploy-" + $init
# $deploymentName = $init + "AZLab"  # Not required

# Use these if you want to drive the deployment from local template and parameter files..
#
#$localAssets = "D:\GitHub\AADSCDemo\"
# $templateFileLoc = $localAssets + "azuredeploy.json"
# $parameterFileLoc = $localAssets + "azuredeploy.parameters.json"

# Use these if you want to drive the deployment from Github-based template. 
#
# If the rawgit.com path is not available, you can try un-commenting the following line instead...
$templateFileURI = "https://raw.githubusercontent.com/KevinRemde/SlotsOFunWebDeploy/master/azuredeploy.json"
# $parameterFileURI = $assetLocation + "azuredeploy.parameters.json" # Use only if you want to use Kevin's defaults (not recommended)


# Use Test-AzureRmDnsAvailability to create and verify unique DNS names.	
#
# Based on the initials entered, find unique DNS names for the four virtual machines.
# NOTE: You may be wondering why I'm not also looking for unique storage account names.  
# Those names are created by the template using randomly generated complex names, based on 
# the resource group ID.


$siteName = "testsite" + $init
$hostingPlanName = "testsiteplankar"
$sku = "D1"
$workerSize = "0"
$repoURL = "https://github.com/tonysurma/BranchedWebSiteForDemos.git"
$branch = "master"

# Populate the parameter object with parameter values for the azuredeploy.json template to use.

$parameterObject = @{
    "siteName" = $siteName
    "hostingPlanName" = $hostingPlanName 
    "sku" = $sku
    "workerSize" = $workerSize
    "repoURL" = $repoURL
    "branch" = $branch
    }



# Create the resource group if it doesn't exist

New-AzureRmResourceGroup -Name $rgname -Location $loc -Force
   
# Build the lab machines. 
# Note: takes approx. 30 minutes to complete.

Write-Host ""
Write-Host "Deploying the site.  This will take several minutes to complete."
Write-Host "Started at" (Get-Date -format T)
Write-Host ""

# THIS IS THE MAIN ONE YOU'LL launch to pull the template file from the repository, and use the created parameter object.
Measure-Command -expression {New-AzureRMResourceGroupDeployment -ResourceGroupName $rgName -TemplateUri $templateFileURI -TemplateParameterObject $parameterObject}


Write-Host ""
Write-Host "Completed at" (Get-Date -format T)

# Delete the entire resource group (and all of its VMs and other objects).
# Remove-AzureRmResourceGroup -Name $rgName -Force





