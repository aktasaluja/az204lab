#install azure powershell module
Install-Module -Name az -Scope AllUsers -Allowclobber
#login to azure
Login-AzAccount
# to list the installed modules
Get-InstalledModule
Set-AzContext -Subscription 6583a37e-de2a-4a28-9cc7-23563a28c4f2

#read the list of resources
Get-AzResourceGroup | Format-Table

#new resource group
New-AzResourceGroup -Name ps-lab-grp -Location 'East US' 

$tags +=@{Environment='lab'}
#mention which resource grup this env variable belongs to
Set-AzResourceGroup -ResourceGroupName ps-lab-grp -Tag $tags

#Remove resource group
#Remove -AzResourceGroup -Name ps-lab-grp

#Deploy webapp
$appurl = "https://github.com/Azure-Samples/app-service-web-dotnet-get-started.git"
$myurl = "https://github.com/aktasaluja/az204lab.git"

$webappname = "mywebapp$(Get-Random)"
$location = "eastus"

New-AzAppServicePlan -AzResourceGroup -Name ps-lab-grp - Location 'East US' -Tier Free -Name ps-asp-900

New-AzWebApp -Name $webappname -Location $location -AppServicePlan ps-asp-900 -ResourceGroupName ps-lab-grp 

# Create deployment resource manually using ARM

$PropertiesObject = @{
    repoUrl = "$appurl";
    branch = "master";
    isManualIntegration = "true";
}

Set-AzResource -PropertyObject $PropertiesObject -ResourceGroupName ps-lab-grp -ResourceType Microsoft.Web/sites/sourcecontrols -ResourceName $webappname/web -ApiVersion 2015-08-01 -Force