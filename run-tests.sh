#!/bin/bash

set -e
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID 
az account set -s $ARM_SUBSCRIPTION_ID
SUBTRUE=$(az account show --query "isDefault")
SUBID=$(az account show --query "id")
SUBID=$(sed -e 's/^"//' -e 's/"$//' <<<"$SUBID")
if [ "$SUBTRUE" -eq "true" ] -&& [ "$SUBID" -eq "$ARM_SUBSCRIPTION_ID" ] ; then
echo "they are true"
else
    echo "they are not true"
fi

# Run the tests
cd ./test/
go test -v -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output




else
    echo "Not in the correct subscription, exiting"
fi
#verifiy correct subscription

# ensure dependencies
#dep ensure

# go mod init github.com/PinportLtd/TerraformModules
# go mod vendor
# set environment variables
# export TF_VAR_service_principal_client_id=$SERVICE_PRINCIPAL_CLIENT_ID
# export TF_VAR_service_principal_client_secret=$SERVICE_PRINCIPAL_CLIENT_SECRET

# run test
