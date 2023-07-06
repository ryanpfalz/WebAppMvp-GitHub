# https://learn.microsoft.com/en-us/azure/load-testing/quickstart-create-and-run-load-test?tabs=virtual-users
# https://learn.microsoft.com/en-us/cli/azure/load?view=azure-cli-latest
# https://techcommunity.microsoft.com/t5/apps-on-azure-blog/azure-load-testing-you-can-run-load-tests-from-command-line-now/ba-p/3857629

# TODO deploy this resource as part of shared/common RG via IaC, parameterize the operations\loadtests\load.jmx URI
$loadTestName = "webappmvploadtest"
$resourceGroupName = "webappmvp-dev"
az load create --name $loadTestName --resource-group $resourceGroupName --location "eastus" # not available for centralus

# open the load test in the portal

# TODO create test with jmx file via CLI - raised issue: https://github.com/Azure-Samples/azure-load-testing-samples/issues/14
# $testId = "JMXTest"
# $testPlan = "./operations/loadtests/load.jmx"
# az load test create --load-test-resource  $loadTestName --test-id $testId  --display-name $testId --description "Created using Az CLI" --test-plan $testPlan --engine-instances 1
