Terraform on Azure Sample Build Scenarios

Environment_Build using Server List in CSV File (csvdecode function) sample:
1. environment_build.csv - contains build environment details in csv format to be used by terraform 
2. main.tf - azure provider version and resource group
3. network.tf - network resources
4. vm_instance.tf - vm instance resources including csvdecode function using a for loop
5. output.tf - contains output of the local admin pw for vm instance
