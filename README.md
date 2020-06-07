Terraform on Azure Sample Build Scenarios

1.environment_build 
Description: Use Terraform to build an environment using server list in CSV File (csvdecode function). Contains the following:
- environment_build.csv - contains build environment details in csv format to be used by terraform 
- main.tf - azure provider version and resource group
- network.tf - network resources
- vm_instance.tf - vm instance resources including csvdecode function using a for loop
- output.tf - contains output of the local admin pw for vm instance
