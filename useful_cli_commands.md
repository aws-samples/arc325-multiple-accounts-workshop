

Get the list of Organizational Units under root organization.
```
aws organizations list-organizational-units-for-parent --region us-east-1 --profile billing --query 'OrganizationalUnits[*].{Id: Id, Name:Name}' --output table  --parent-id r-abcd
```

Get the list of events in a CloudFormation stack
```
aws cloudformation describe-stack-events --region eu-west-1 --output table --query 'StackEvents[*].{LogicalId:LogicalResourceId, ResourceType: ResourceType, Status: ResourceStatus}' --profile billing --stack-name CostOptimizationMonitor
```

Get the list of resources in CloudFormation stack
```
aws cloudformation describe-stack-resources --region eu-west-1 --query 'StackResources[*].{ResourceId: LogicalResourceId, Type: ResourceType, Status:ResourceStatus}' --output table --profile billing --stack-name CostOptimizationMonitor
```
