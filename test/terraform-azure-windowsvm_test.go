package testwindowsvm

import (
	"fmt"
	"github.com/Azure/azure-sdk-for-go/services/compute/mgmt/2019-07-01/compute"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
	"testing"
	//"reflect"
	"strings"
)

func TestWindowsvm(t *testing.T) {

	// Run tests in Parrallel
	t.Parallel()

	// Setup the infrastructure dependencies paths and variables
	depOpts := &terraform.Options{
		TerraformDir: "./dependencies",
		VarFiles:     []string{"testing.tfvars"},
	}

	// Equivalent of running Terraform destroy for dependenciesopts
	defer terraform.Destroy(t, depOpts)

	// Equivalent of running Terraform init, Terraform apply for dependenciesopts
	terraform.InitAndApply(t, depOpts)

	// Setup the infrastructure paths and variables
	opts := &terraform.Options{
		TerraformDir: "./fixture",
	}

	// Equivalent of running Terraform Destroy for opts
	defer terraform.Destroy(t, opts)

	//Equivalent of running Terraform init, Terraform apply for opts
	terraform.InitAndApply(t, opts)

	// Setting Variables
	vmNameList := terraform.Output(t, opts, "vm_names")
	resourceGroupList := terraform.Output(t, opts, "resourcegroup")
	// Tidy up outputs

	replacer := strings.NewReplacer(" ", "", "[", "", "]", "", "\"", "", ",", "")

	resourceGroupList = replacer.Replace(resourceGroupList)
	resourceGroupList = strings.TrimSpace(resourceGroupList)

	vmNameList = replacer.Replace(vmNameList)
	vmNameList = strings.TrimSpace(vmNameList)

	vmNames := strings.Fields(vmNameList)

	resourceGroups := strings.Fields(resourceGroupList)
	resourceGroups = uniqueNonEmptyElementsOf(resourceGroups)

	fmt.Println("Resource Group: ", resourceGroups)

	for _, resourceGroup := range resourceGroups {
		fmt.Println("ResourceGroup: ", resourceGroup)

		// Check the size of the Virtual Machine
		for _, vmName := range vmNames {
			fmt.Println("Virtual Machine: ", vmName)
			testVMSize := azure.GetSizeOfVirtualMachine(t, vmName, resourceGroup, "")
			expectedVMSize := compute.VirtualMachineSizeTypes("Standard_B2ms")
			fmt.Println("The Size of the Virtual Machine is as it should be as expected: ", assert.Equal(t, expectedVMSize, testVMSize))

			// Check that it's got a Public IP assigned.
			var checkItsGotPip bool
			checkItsGotPip = azure.PublicAddressExists(t, (vmName + "-PIP"), resourceGroup, "")
			fmt.Println("Checking if a Public IP has been assigned to the VM: ", assert.Equal(t, true, checkItsGotPip))

			// Get the Public IP address checks if it exists.
			getIPAddress := azure.GetIPOfPublicIPAddressByName(t, (vmName + "-PIP"), resourceGroup, "")
			fmt.Println("This is the Public IP address ", getIPAddress)
			fmt.Println("Checking what is the IP Address of the Virtual Machine: ", assert.NotEmpty(t, getIPAddress))

		}

	}

}

func uniqueNonEmptyElementsOf(s []string) []string {
	unique := make(map[string]bool, len(s))
	us := make([]string, len(unique))
	for _, elem := range s {
		if len(elem) != 0 {
			if !unique[elem] {
				us = append(us, elem)
				unique[elem] = true
			}
		}
	}

	return us

}
