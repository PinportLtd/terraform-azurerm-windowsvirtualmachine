package windowsvmtest

import (
	"fmt"
	"testing"
	"github.com/gruntwork-io/terratest"
	
)

func TestWindowsvm(t *testing.T) {
	opts := &terraform.Options{
		TerraformDir: "../examples/simple",
	}

	// Deploy the Infra
	terraform.InitAndApply(t, opts)

	// get the DNS name of the machine
	vmDNSName := terraform.OutputRequired(t, opts, "fqdn")

	url	:= fmt.Sprintf("http://%s", vmDNSName)

	// test the url is working

}