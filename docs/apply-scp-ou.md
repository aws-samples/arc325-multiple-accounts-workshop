As part of this module you will create a Service Control Policy, apply it to an Organizational Unit and validate it.

> This should be performed on Billing account in **North Virginia (us-east-1)** region.
> 
> This should be performed on Application One account in **Ireland (eu-west-1)** region.

**Table of Contents:**
-   [Create Service Control Policy](#create-service-control-policy)
-   [Enable Service control policies at root](#enable-service-control-policies-at-root)
-   [Attach Service Control Policy to Applications OU](#attach-service-control-policy-to-applications-ou)
-   [Test the Service Control Policy](#test-the-service-control-policy)
-   [Expected Outcome](#expected-outcome)


## Create Service Control Policy

1.  Login to your [AWS Management Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1) and navigate to [AWS Organizations](https://console.aws.amazon.com/organizations/home) console.
2.  On the Policies tab, choose Create Policy.
3.  Choose **Policy generator** as the technique to create the policy.
4.  Type a name as `DenyRDSAccess` and description as 'Deny access to RDS Service'.
5.  Under Choose Effect follow the below steps
    *   _Choose Overall Effect:_ Select the 'Deny' check box and leave 'Allow' unchecked.
    *   _Statement Builder:_ Click 'Select Service' dropdown, search for 'RDS' and select Amazon RDS. Click 'Select Action' and select 'Select All'.
6.  Click 'Add statement' which will add the above policy statement.
7.  Click 'Create Policy', it will create the Service Control Policy.

**Using CLI:**

Create the Service Control Policy using the policy file 'SCPDenyRDS.json' located in the root of the repo.

```
aws organizations create-policy --region us-east-1 --profile billing --name DenyRDSAccess --type SERVICE_CONTROL_POLICY --description "Deny access to RDS Service" --content file://SCPDenyRDS.json
```

```json
{
    "Policy": {
        "Content": "{\n    \"Version\": \"2012-10-17\",\n    \"Statement\": [\n        {\n            \"Sid\": \"DenyRDSAccess\",\n            \"Effect\": \"Deny\",\n            \"Action\": [\n                \"rds:*\"\n            ],\n            \"Resource\": [\n                \"*\"\n            ]\n        }\n    ]\n}\n",
        "PolicySummary": {
            "AwsManaged": false,
            "Description": "Deny access to RDS Service",
            "Type": "SERVICE_CONTROL_POLICY",
            "Id": "p-lexample",
            "Arn": "arn:aws:organizations::123456789012:policy/o-ckoexample/service_control_policy/p-lexample",
            "Name": "DenyRDSAccess,"
        }
    }
}
```
> Note: Store the value of policy Id returned as the output of above command in `ResourcesList.txt` file.

## Enable Service control policies at root

1.  Navigate to 'Organize Accounts' tab and click 'Enable' for 'Service control policies' at the bottom right under "Enable / Disable Policy Types"

**Using CLI**

Update the value for parameter `--root-id` in the below command to your organization root ID and execute it.

<code>aws organizations enable-policy-type --region us-east-1 --profile billing --policy-type SERVICE_CONTROL_POLICY --root-id <b><i>r-abcd</i></b>
</code><br>

```json
{
    "Root": {
        "PolicyTypes": [],
        "Id": "r-abcd",
        "Arn": "arn:aws:organizations::123456789012:root/o-ckexample/r-abcd",
        "Name": "Root"
    }
}
```

## Attach Service Control Policy to Applications OU

1.  Click 'Applications' OU which will open the OU. In the bottom right, click "Service Control Policies" under 'POLICIES'. It will display the list of available service control policies.
2.  Click 'Attach' next to the SCP named 'DenyRDSAccess'.

**Using CLI**

Update the value for parameters `--policy-id` with the value of SCP policy ID and `--target-id` with ID of the Applications OU.

<code>aws organizations --region us-east-1 --profile billing attach-policy --policy-id <b><i>p-lexample</i></b> --target-id  <b><i>ou-abcd-7example</i></b>
</code><br>

Check the list of policies attached to Applications OU.

<code>
aws organizations --region us-east-1 --profile billing list-policies-for-target --filter SERVICE_CONTROL_POLICY --query 'Policies[&#42;].{PolicyName:Name, Description:Description}' --output table --target-id <b><i>ou-abcd-7example</i></b>
</code><br>


```text
--------------------------------------------------------
|                 ListPoliciesForTarget                |
+-----------------------------------+------------------+
|            Description            |   PolicyName     |
+-----------------------------------+------------------+
|  Allows access to every operation |  FullAWSAccess   |
|  Deny access to RDS Service       |  DenyRDSAccess  |
+-----------------------------------+------------------+
```

## Test the Service Control Policy
1.  Login to "Application One Account" with **PayerAccountAccessRole** role created as part of account creation using the [cross account switch role](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html) capability.
2.  Navigate to Amazon RDS service console and try to 'Launch Instance' or 'List DB Subnet Groups' and the access should be restricted.

**Using CLI**

Execute `describe-db-instances` command and it should fail with permission error.

```
aws rds describe-db-instances --region eu-west-1 --profile appone
```

## Expected Outcome

*   Created Service Control Policy.
*   Attached Service Control Policy to `Applications` OU.
*   Validated that the services restricted by SCP is not accessible in `Application One` account (even to Administrator).
