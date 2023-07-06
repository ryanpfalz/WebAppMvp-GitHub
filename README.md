| Page Type | Languages                                     | Key Services                    | Tools                                                                                |
| --------- | --------------------------------------------- | ------------------------------- | ------------------------------------------------------------------------------------ |
| Sample    | .NET Core <br> PowerShell <br> Bicep <br> HCL | Azure App Service <br> Azure VM | Terraform <br> Azure CLI <br> Azure DevOps (Pipelines, Releases) <br> GitHub Actions |

---

# Automated Infrastructure as Code & CI/CD Examples

This sample codebase demonstrates how to use Azure DevOps or GitHub to provision PaaS or IaaS infrastructure with either Bicep or Terraform, and then release a basic web application to that infrastructure with CI/CD in either Azure Pipelines or GitHub Actions.

This example enables infrastructure to be provisioned for multiple environments (Dev, QA) and released/promoted to the environments via an approval process in the CI/CD process. The same web application codebase is deployed into the hosting environments with whichever toolset you choose (GitHub/Azure DevOps, Bicep/Terraform), with configuration driven by build- or release-time variables.

The goal of this codebase is to provide an example of how to use some of the best-in-class tools and approaches to deploying consistent environments and applications, and provide an easily modifiable starting point for your applications.

Please note that this coodebase is actively under development and not every combination of hosting environment and IaC + CI/CD tool has been built yet.

## Prerequisites

- [An Azure Subscription](https://azure.microsoft.com/en-us/free/) - for hosting cloud infrastructure
- [An Azure DevOps Organization + Project](https://azure.microsoft.com/en-us/products/devops/) - for managing code and running Pipelines
- [A GitHub account](https://github.com/) - for managing code and running Actions
- [Terraform](https://www.terraform.io/) - for working with HCL infrastructure as code files
- [Bicep tools](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install) - for working with Bicep infrastructure as code files
- [Az CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli) - for executing Azure commands
- [.NET Core](https://dotnet.microsoft.com/en-us/download/dotnet/6.0) - for web application and Playwright development
- [Visual Studio](https://visualstudio.microsoft.com/) - for development

## Running this sample

### Running the web application

- The .NET solution/CS Project in the `web\DemoWebApplication` directory contains the web project. While you will replace your actual application with this one, I recommend starting with understanding how the release process for this sample application works. When you introduce your application, it will likely require modifications to the CI/CD files to reflect your frameworks and dependencies, as well as updates to the infrastructure as code files to reflect your architecture.

### Azure DevOps

#### Create Service Connection:

Follow [this guide](https://learn.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) to set up a service conection with your Azure subscription.

#### Create Variable Group:

In the files `infra\scripts\iaas-variables.ps1` and `infra\scripts\paas-variables.ps1`, insert variable values and execute the script for both Dev & QA environments. These variables will be used to drive your IaC and CI/CD processes. The `infra\scripts\tf-backend-variables.ps1` file should be populated with a values for a shared Terraform resource group that will be used to manage Terraform state across environments.

These variables are referenced in the pipeline files; for example, see the 'environment' parameter in `.azure-pipelines\infra\deploy\bicep-pipeline-paas.yml`. The names of the variable groups you create should be overridden with the variable group name parameters populated in the '.azure-pipelines' directory. I named my variable groups '_WebAppVarsDev_', '_WebAppVarsQA_' , '_IaaSWebAppVarsDev_', '_IaaSWebAppVarsQA_', and '_TerraformVars_'.

These variable groups can be accessed under Pipelines > Library.

#### Set up environment

The environments will be used to set up approvals for deployment into your environments. The environments need to be created in the DevOps portal. Follow [this guide](https://learn.microsoft.com/en-us/azure/devops/pipelines/process/environments?view=azure-devops) to create them. You'll need to update the environment used in the CI/CD pipeline files; for example, in the Deploy stages of `.azure-pipelines\app\webapp-cicd-paas.yml`, you'll need to update the 'environment' key to reflect your own environments. I named my environments '_WebAppMVP-Dev_' and '_WebAppMVP-QA_'.

#### Set up pipelines

##### For PaaS:

1. In Pipelines > Pipelines, create pipeline for both the Infrastructure as Code and CI/CD pipelines. Here are the corresponding files:
   - IaC w/ Bicep (provisioning): `.azure-pipelines\infra\deploy\bicep-pipeline-paas.yml`
   - IaC w/ Terraform (provisioning): `.azure-pipelines\infra\deploy\tf-pipeline-paas.yml`
   - CI/CD: `.azure-pipelines\app\webapp-cicd-paas.yml`

##### For IaaS:

1. In Pipelines > Pipelines, create pipeline for both the Infrastructure as Code and CI, and in Pipelines > Release create a CD pipeline. Here are the corresponding files:

   - IaC w/ Bicep (provisioning): `.azure-pipelines\infra\deploy\bicep-pipeline-iaas.yml`
   - IaC w/ Bicep (destroying): `.azure-pipelines\infra\destroy\bicep-pipeline-iaas-destroy.yml`
   - CI: `.azure-pipelines\app\webapp-ci-iaas.yml`
   - CD: `.azure-pipelines\infra\deploy\WebApp-IaaS-App-CD.json`. You'll need to modify the pipeline to use your service connections and deployment group (described further below).

2. Install [Terraform extension](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks&targetId=be306e75-95ac-461a-a54e-5fd100dbb1b8&utm_source=vstsproduct&utm_medium=ExtHubManageList) from marketplace into your Azure DevOps organization.

##### For both IaC tools:

1. Link the variable groups created above to each of the associated pipelines (e.g., any PaaS pipeline should be related with the PaaS variable groups, any Terraform pipeline should be related with the Terraform variable group, etc.).

#### Notes on Azure DevOps setup

At this point, you should be able to run the pipelines successfully. Here are some notes:

- Run the Infrastructure as Code pipelines first. The IaC and CI/CD pipelines are deliberately kept separate in this codebase, but they can easily be combined.
- The PaaS CI/CD pipelines heavily refer to [this documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/ecosystems/dotnet-core?view=azure-devops&tabs=dotnetfive).
- The IaaS CI/CD pipelines heavily refer to [this documentation](https://learn.microsoft.com/en-us/azure/devops/pipelines/apps/cd/deploy-webdeploy-iis-deploygroups?view=azure-devops&tabs=net) and [this lab](https://azuredevopslabs.com/labs/vstsextend/deploymentgroups/). Notably:
  - You need to create a VM deployment group in Azure DevOps before running the CD pipeline
  - IIS is enabled in the CD pipeline
  - A new service connection needs to be created with a PAT
  - The VMs in your resource group are automatically registered with the deployment group by using the "Azure Resource Group Geployment" task (version 2.\*, _not_ 3.\*). [This lab](https://azuredevopslabs.com/labs/vstsextend/deploymentgroups/) describes the steps in detail.
  - The [Windows Hosting Bundle (for .NET 6.x)](https://dotnet.microsoft.com/en-us/download/dotnet/6.0) is installed on the VMs in the IaC setup using `infra\scripts\install-win-hosting-bundle.ps1`. If the site doesn't work after deploy, the program may need to be repaired on the VM.
  - [This guide](https://learn.microsoft.com/en-us/archive/blogs/rakkimk/iis7-how-to-enable-the-detailed-error-messages-for-the-website-while-browsed-from-for-the-client-browsers) describes how to troubleshoot error messages from the client browser.
