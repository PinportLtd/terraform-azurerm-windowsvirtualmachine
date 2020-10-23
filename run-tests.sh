#!/bin/bash

set -e
# required to login to Azure to allow terratest test to run
az login --service-principal --username $ARM_CLIENT_ID --password $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID 
az account set -s $ARM_SUBSCRIPTION_ID

# check it's logged into the correct subscription before deploying the test infrastructure.
SUBTRUE=$(az account show --query "isDefault")
SUBID=$(az account show --query "id")
SUBID=$(sed -e 's/^"//' -e 's/"$//' <<<"$SUBID")
if [ "$SUBTRUE" -eq "true" ] -&& [ "$SUBID" -eq "$ARM_SUBSCRIPTION_ID" ] ; then

# Run the tests
cd ./test/
mkdir test_output
go test -v -timeout 30m | tee test_output.log
terratest_log_parser -testlog test_output.log -outputdir test_output

else
    echo "Not in the correct subscription, exiting"
fi

