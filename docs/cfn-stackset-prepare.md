Create CloudFormation StackSet Admin IAM Role in `WorkShop` account and CloudFormation StackSet Execution IAM Role in `WorkShop` and `Billing` accounts.

> Use **Ireland (eu-west-1)** to create all resources.

**Table of Contents:**
-   [Create IAM role required for AWS CloudFormation StackSet Administration](#create-iam-role-required-for-aws-cloudformation-stackset-administration)
-   [Create IAM role required for AWS CloudFormation StackSet Execution](#create-iam-role-required-for-aws-cloudformation-stackset-execution)


## Create IAM role required for AWS CloudFormation StackSet Administration
> This should be performed in `WorkShop` Account.

1.  Login to "WorkShop Account" with **PayerAccountAccessRole** role created as part of account creation using the [cross account switch role](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html) capability.

2.  Change the region to Ireland (eu-west-1) by [selecting the region](http://docs.aws.amazon.com/awsconsolehelpdocs/latest/gsg/getting-started.html#select-region) from the top right of Management Console.

3.  Navigate to [CloudFormation](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks?filter=active) console and create a new stack using [AWSCloudFormationStackSetAdministrationRole.yml](../templates/AWSCloudFormationStackSetAdministrationRole.yml) template.

**Using CLI:**

Navigate to `templates` folder which contains all the CloudFormation templates.

```
aws cloudformation create-stack --stack-name CFNStackSetAdminRole --template-body file://AWSCloudFormationStackSetAdministrationRole.yml --capabilities CAPABILITY_NAMED_IAM --region eu-west-1 --profile workshop
```
```json
{
    "StackId": "arn:aws:cloudformation:eu-west-1:321098987654:stack/CFNStackSetAdminRole/7626db50-bae3-11e7-1867-50d5cafe76fe"
}
```
## Create IAM role required for AWS CloudFormation StackSet Execution

> This should be performed in `Billing` and `WorkShop` accounts in Ireland (eu-west-1) region.

1.  Login to "WorkShop Account" with **PayerAccountAccessRole** role created as part of account creation using the [cross account switch role](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html) capability.

2.  Change the region to Ireland (eu-west-1) by [selecting the region](http://docs.aws.amazon.com/awsconsolehelpdocs/latest/gsg/getting-started.html#select-region) from the top right of Management Console.

3.  Navigate to [CloudFormation](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks?filter=active) console and create a new stack using [AWSCloudFormationStackSetExecutionRole.yml](../templates/AWSCloudFormationStackSetExecutionRole.yml) template. Provide the 12 digit AWS account ID of the Shared Services account as parameter. This stack will create an IAM role in Security account which will allow CloudFormation StackSet in Shared Services account to create stacks in Security account.

    **Using CLI:**  

    Navigate to `templates` folder which contains all the CloudFormation templates.

    Update the ParameterValue in the below command to 12 digit AWS account ID of WorkShop account.

    ```
    aws cloudformation create-stack --stack-name CFNStackSetExecutionRole --template-body file://AWSCloudFormationStackSetExecutionRole.yml --capabilities CAPABILITY_NAMED_IAM --region eu-west-1 --parameters ParameterKey=AdministratorAccountId,ParameterValue=321098987654 --profile workshop
    ```

    ```json
    {
        "StackId": "arn:aws:cloudformation:us-east-1:987654321098:stack/CFNStackSetExecutionRole/28a3c090-ba80-11e7-93d4-500c3d1abad2"
    }
    ```

4.  Create a Key Pair
[Create a Key Pair using Amazon EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) and store it securely. It will be needed during the lab.

Or create the key pair [using CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html) and store the returned KeyMaterial securely.

***example linux:***
```bash
$ aws ec2 create-key-pair --profile workshop --key-name lz-workshop-kp-eu-west-1 --query 'KeyMaterial' --output text > lz-workshop-kp-eu-west-1.pem
```

***example windows:***
```shell
aws ec2 create-key-pair --profile workshop --key-name lz-workshop-kp-eu-west-1 --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath lz-workshop-kp-eu-west-1.pem
```

6.  Login to *Billing* account and follow steps 2 to 4 to create the AWSCloudFormationStackSetExecutionRole in that account. Also create KeyPair with appropriate name for the account.

    **Using CLI:**

    Navigate to `templates` folder which contains all the CloudFormation templates.

    Update the ParameterValue in the below command to 12 digit AWS account ID of WorkShop account.

    ```bash
    aws cloudformation create-stack --stack-name CFNStackSetExecutionRole --template-body file://AWSCloudFormationStackSetExecutionRole.yml --capabilities CAPABILITY_NAMED_IAM --region eu-west-1 --parameters ParameterKey=AdministratorAccountId,ParameterValue=321098987654 --profile billing
    ```

    ```bash
    aws ec2 create-key-pair --region eu-west-1 --query 'KeyMaterial' --output text --key-name lz-billing-kp-eu-west-1 --profile billing > lz-billing-kp-eu-west-1.pem
    ```
