#!/bin/bash

set -e

# ensure dependencies
#dep ensure
cd ./test/
go mod init github.com/PinportLtd/TerraformModules
go mod vendor
# set environment variables
# export TF_VAR_service_principal_client_id=$SERVICE_PRINCIPAL_CLIENT_ID
# export TF_VAR_service_principal_client_secret=$SERVICE_PRINCIPAL_CLIENT_SECRET

# run test
go test -v -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output