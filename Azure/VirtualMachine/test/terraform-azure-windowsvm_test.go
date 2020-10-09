package TestWindowsvm

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest/modules/azure"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/hashicorp/terraform/communicator/winrm"
	"github.com/stretchr/testify/assert"
	
)

func TestWindowsvm(t *testing.T) {
	t.Parallel()

	dependenciesopts := $terraform.Options{
		TerraformDir: "./dependencies",
		VarFiles: [string]{"testing.tfvars"},
	}

	defer terraform.Destroy(t, dependenciesopts)
	terraform.InitAndApply(t, dependenciesopts)


	opts := &terraform.Options{
		TerraformDir: "./fixture",
		VarFiles: [string]{"testing.tfvars"},
	}


	defer terraform.Destroy(t, opts)
	terraform.InitAndApply(t, opts)


	// Clean up everything at the end of the test
	defer terraform.Destroy(t, opts)
	// Deploy the Infra
	terraform.InitAndApply(t, opts)

	// get the DNS name of the machine
	vmDNSName := terraform.OutputRequired(t, opts, "fqdn")

	url	:= fmt.Sprintf("http://%s", vmDNSName)
	fmt.Printf("This should be the URL%s.\n", url)

	vmname := "foo00"
	resourcegroup := "DeathRace"
	subscriptionID := "206c6b04-b170-42cf-ab78-0703dbd83bdc"

	testvmsize := GetSizeOfVirtualMachine(t, vmanme, resourcegroup, subscriptionID)

	fmt.Println("This will hopefully be the size of the VM", testvmsize)
	
}

