As part of this module you will deploy and configure the [Cross Account Manager](http://docs.aws.amazon.com/solutions/latest/cross-account-manager/architecture.html)

> This should be performed on Shared Services account in **Ireland (eu-west-1)** region.

**Table of Contents:**
-   [Launch the Cross Account Manager (master role) in Shared Services Account](#launch-the-cross-account-manager-master-role-in-shared-services-account)
-   [Configure sub accounts in Cross Account Manager](#configure-sub-accounts-in-cross-account-manager)
-   [Launch the Cross Account Manager (sub role)](#launch-the-cross-account-manager-sub-role)
-   [Onboard Policies and Roles](#onboard-policies-and-roles)
-   [Assign IAM Roles to your Active Directory Groups](#assign-iam-roles-to-your-active-directory-groups)
-   [Use the solution webpage to access a sub-account](#use-the-solution-webpage-to-access-a-sub-account)


## Launch the Cross Account Manager (master role) in Shared Services Account

> Shared Services Account will act as the Cross Account Manager Master

1.  Login to "Shared Services Account" with **PayerAccountAccessRole** role created as part of account creation using the [cross account switch role](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-console.html) capability.

2.  Change the region to Ireland (eu-west-1) by [selecting the region](http://docs.aws.amazon.com/awsconsolehelpdocs/latest/gsg/getting-started.html#select-region) from the top right of Management Console.

3.  Navigate to [CloudFormation](https://eu-west-1.console.aws.amazon.com/cloudformation/home?region=eu-west-1#/stacks?filter=active) console and create a new stack using [aws-cross-account-manager-master.yml](../templates/aws-cross-account-manager-master.yml) template.

4.  Provide a Stack Name (E.g. CrossAccountManager), review the parameters ("AccessLinksBucket" & "ConfigBucket") and provide a valid name for S3 buckets following the [bucket naming rules](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html#bucketnamingrules) (e.g. lz-cross-account-manager-access-links-&lt;five random letters&gt;).

5.  Select the checkbox under Capabilities in subsequent pages to allow CloudFormation to create IAM resources.

6.  Create the stack.

7.  It will take few minutes to complete the stack creation. Once it’s been completed save the following values from the output section of the stack.

    -   CAMConfigBucket
    -   AccessLinksBucket
    -   KMSKeyAlias

**Using CLI:**

1.  Move into the directory named templates which contains the CloudFormation templates and parameters file.

2.  Open [aws-cross-account-manager-master-parameters.json](../templates/aws-cross-account-manager-master-parameters.json) in your favorite text editor and review the parameters.

3.  Update the ParameterValue of the following ParameterKeys.

    -   AccessLinksBucket - Provide a valid name for S3 buckets following the [bucket naming rules](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html#bucketnamingrules) (e.g. lz-cross-account-manager-access-links-&lt;five random letters&gt;).
    -   ConfigBucket - provide a valid name for S3 buckets following the [bucket naming rules](http://docs.aws.amazon.com/AmazonS3/latest/dev/BucketRestrictions.html#bucketnamingrules) (e.g. lz-cross-account-manager-config-&lt;five random letters&gt;).

4.  Create the stack using following command.
    ```
    aws cloudformation create-stack --stack-name CrossAccountManager --capabilities CAPABILITY_NAMED_IAM --region eu-west-1 --profile sharedserv --template-body file://aws-cross-account-manager-master.yml --parameters file://aws-cross-account-manager-master-parameters.json
    ```
    ```json
    {
        "StackId": "arn:aws:cloudformation:us-east-1:321098987654:stack/CrossAccountManager/3d1abad2-ba80-11e7-93d4-28a3c090500c"
    }
    ```

5.  Once the stack got created successfully get the output values of the stack using the following command.
    ```
    aws cloudformation describe-stacks --stack-name CrossAccountManager --region eu-west-1 --profile sharedserv --query 'Stacks[0].Outputs[*].{Key:OutputKey,Value:OutputValue}' --output table
    ---------------------------------------------------------------------
    |                          DescribeStacks                           |
    +--------------------+----------------------------------------------+
    |         Key        |                    Value                     |
    +--------------------+----------------------------------------------+
    |  CAMConfigBucket   | lz-cross-account-manager-config-prakash      |
    |  KMSKeyAlias       | alias/CrossAccountManager-Key                |
    |  AccessLinksBucket | lz-cross-account-manager-access-links-prakash|
    |  UUID              | 78e55241-abcd-wxyz-stuv-df75eda35ae4         |
    |  AnonymousData     | No                                           |
    +--------------------+----------------------------------------------+
    ```

## Configure sub accounts in Cross Account Manager

1.  Open the file [account.yml](../CrossAccountManager/account.yml) which located inside CrossAccountManager directory in your favorite text editor.

2.  Update the 12 digit account id of your `Billing`, `Security` and `Application One` accounts in the appropriate field and save the file.

3.  Navigate to [Amazon S3 Console](https://s3.console.aws.amazon.com/s3/home?region=eu-west-1#) and open the 'ConfigBucket' bucket that was created in the previous procedure and open the `account` folder.

4.  Upload the account file. In the upload pop-up at 'Set Properties' stage, under 'Encryption' select the check box 'AWS KMS master-key' and use the solution-generated AWS KMS key (KMSKeyAlias output from the previous procedure) to encrypt the object during upload (see the [AWS KMS Developer Guide](http://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) for detailed instructions).

    **Using CLI:**

    1.  Get the KMS Key Id using the below command. Make sure you search the correct KMS Key using the KMSKeyAlias obtained from the output of CFN stack from previous procedure and use that for '\[?AliasName==\`alias/CrossAccountManager-Key\`\]'

        ```
        aws kms list-aliases  --profile sharedserv --region eu-west-1 --query 'Aliases[?AliasName==`alias/CrossAccountManager-Key`].{KMSKeyId:TargetKeyId}' --output text

        b44a4526-abcd-0707-wxyz-e299c63423da
        ```

    2.  Upload the account.yml file inside CrossAccountManager directory to the 'account' directory in `CAMConfigBucket` S3 bucket. Update the S3 location & `--sse-kms-key-id` parameter to the value obtained in the above step 1.

        ```
        aws s3 cp account.yml --region eu-west-1 --profile sharedserv s3://lz-cross-account-manager-config-prakash/account/ --sse aws:kms --sse-kms-key-id b44a4526-abcd-0707-wxyz-e299c63423da

        upload: ./account.yml to s3://lz-cross-account-manager-config-prakash/account/account.yml
        ```

5.  If the upload is successful, the solution will remove the account file from the configuration bucket. Check the account folder to confirm the file was received and removed. (It will remain in the bucket’s version history.) You can also check [Amazon DynamoDB](http://docs.aws.amazon.com/solutions/latest/cross-account-manager/appendix-a.html#ddb-tables) to confirm the account record(s) were added successfully.

    **Using CLI:**
    -   Scan the accounts DynamoDB table to see whether the accounts got added.
    ```
        aws dynamodb scan --table-name CrossAccountManager-Accounts --region eu-west-1 --profile sharedserv --query 'Items[*].{AccountId:AccountId.S,AccountGroup:AccountGroup.S,Status:Status.S}' --output table
    ```
    ```text
        ---------------------------------------------
        |                   Scan                    |
        +---------------+----------------+----------+
        | AccountGroup  |   AccountId    | Status   |
        +---------------+----------------+----------+
        |  devops       |  654321987098  |  pending |
        |  billing      |  123456789012  |  pending |
        |     *         |  987654321098  |  pending |
        +---------------+----------------+----------+
    ```
    > **Note:**
    >
    > You must successfully upload the account file to the configuration bucket before you continue to the next step.

## Launch the Cross Account Manager (sub role)

1.  Navigate to [CloudFormation StackSets](https://eu-west-1.console.aws.amazon.com/cloudformation/stacksets/home?region=eu-west-1#/stacksets) console and create a new StackSet using [aws-cross-account-manager-sub.yml](../templates/aws-cross-account-manager-sub.yml) template.

2.  Provide the StackSet Name `CrossAccountManager`, then enter 12 digit account Id of your Shared Services Account (Cross Account Manager Master) for `MasterAccountID` parameter and proceed by clicking 'Next'.

3.  Enter the 12 digit account ID of `Billing`, `Security`, and `Application One` accounts as comma separated under 'Deploy stacks in accounts' field.

4.  Add 'EU (Ireland)' in the 'Specify Regions' field.

5.  Proceed by clicking 'Next' and create the StackSet.

**Using CLI:**

1.  Move into the directory named templates which contains the CloudFormation templates and parameters file.

2.  Create the StackSet named `CrossAccountManager` using following command. Update the ParameterValue for MasterAccountID to be 12 digit account Id of your Shared Services Account (Cross Account Manager Master).

    ```
    aws cloudformation create-stack-set --stack-set-name CrossAccountManager --capabilities CAPABILITY_NAMED_IAM --template-body file://aws-cross-account-manager-sub.yml --region eu-west-1 --profile sharedserv --parameters ParameterKey=MasterAccountID,ParameterValue=321098987654
    ```
    ```json
    {
        "StackSetId": "CrossAccountManager:5c54daa1-9155-4d84-6cfc-9b1fdexample"
    }
    ```

3.  Create Stack Instance in `Billing`, `Security`, and `Application One` accounts by providing the 12 digit AWS account id of all the accounts in space separated format to `--accounts` parameter.

    ```
    aws cloudformation create-stack-instances --stack-set-name CrossAccountManager --regions eu-west-1 --operation-preferences FailureToleranceCount=0,MaxConcurrentCount=4 --region eu-west-1 --profile sharedserv --accounts 123456789012 987654321098 654321987098
    ```
    ```json
    {
        "OperationId": "666a05b3-adef-4692-356a-695bfexample"
    }
    ```

## Onboard Policies and Roles

1.  Navigate to [Amazon S3 Console](https://s3.console.aws.amazon.com/s3/home?region=eu-west-1#) and open the 'ConfigBucket' bucket that was created in the previous procedure and open the `custom_policy` folder.

2.  Upload the policies files (all files with .json extension) in the 'CrossAccountManager' directory to S3. In the upload pop-up at 'Set Properties' stage, under 'Encryption' select the check box 'AWS KMS master-key' and use the solution-generated AWS KMS key (KMSKeyAlias output from the previous procedure) to encrypt the object during upload (see the [AWS KMS Developer Guide](http://docs.aws.amazon.com/kms/latest/developerguide/services-s3.html) for detailed instructions).

    **Using CLI:**

    Update the S3 location to `CAMConfigBucket` & `--sse-kms-key-id` parameter

    ```bash
    for pf in Administrator.json Billing.json DBAdmin.json DevOps.json NetworkAdmin.json PowerUser.json ReadOnly.json; do echo "Uploading $pf to S3"; aws s3 cp  --region eu-west-1 --profile sharedserv $pf s3://lz-cam-config-attempt1/custom_policy/ --sse aws:kms --sse-kms-key-id b44a4526-abcd-0707-wxyz-e299c63423da; done
    ```
    _Output:_
    ```
    Uploading Administrator.json to S3
    upload: ./Administrator.json to s3://lz-cross-account-manager-config-prakash/custom_policy/Administrator.json
    Uploading Billing.json to S3
    upload: ./Billing.json to s3://lz-cross-account-manager-config-prakash/custom_policy/Billing.json
    Uploading DBAdmin.json to S3
    upload: ./DBAdmin.json to s3://lz-cross-account-manager-config-prakash/custom_policy/DBAdmin.json
    Uploading DevOps.json to S3
    upload: ./DevOps.json to s3://lz-cross-account-manager-config-prakash/custom_policy/DevOps.json
    Uploading NetworkAdmin.json to S3
    upload: ./NetworkAdmin.json to s3://lz-cross-account-manager-config-prakash/custom_policy/NetworkAdmin.json
    Uploading PowerUser.json to S3
    upload: ./PowerUser.json to s3://lz-cross-account-manager-config-prakash/custom_policy/PowerUser.json
    Uploading ReadOnly.json to S3
    upload: ./ReadOnly.json to s3://lz-cross-account-manager-config-prakash/custom_policy/ReadOnly.json
    ```
    Execute the following command to check whether the files got uploaded successfully to the `CAMConfigBucket` bucket in the `custom_policy` directory.

    ```
    aws s3 ls --region eu-west-1 --profile sharedserv s3://lz-cross-account-manager-config-prakash/custom_policy/

    2017-11-12 12:53:12        132 Administrator.json
    2017-11-12 12:53:12        375 Billing.json
    2017-11-12 12:53:14       3578 DBAdmin.json
    2017-11-12 12:53:15       9044 DevOps.json
    2017-11-12 12:53:16       6536 NetworkAdmin.json
    2017-11-12 12:53:17        378 PowerUser.json
    2017-11-12 12:53:18       6561 ReadOnly.json
    ```

3.  Go back to the configuration bucket and choose the role folder.

4.  Upload the role.yml file. Use the solution-generated AWS KMS key to encrypt the object during upload.

    -   Upload the role.yml file inside CrossAccountManager directory to the 'role' directory in `CAMConfigBucket` S3 bucket. Update the S3 location & `--sse-kms-key-id` parameter to the value obtained in the earlier procedure.

        ```
        aws s3 cp role.yml --region eu-west-1 --profile sharedserv s3://lz-cross-account-manager-config-prakash/role/ --sse aws:kms --sse-kms-key-id b44a4526-abcd-0707-wxyz-e299c63423da

        upload: ./role.yml to s3://lz-cross-account-manager-config-prakash/role/role.yml
        ```

5.  If the upload is successful, the solution will remove the role file from the configuration bucket. Check the role folder to confirm the file was received and removed. (It will remain in the bucket’s version history.) You can also check [Amazon DynamoDB](http://docs.aws.amazon.com/solutions/latest/cross-account-manager/appendix-a.html#ddb-tables) to confirm the account record(s) were added successfully.

    **Using CLI:**

    -   Check the list of roles by scanning the roles DynamoDB table (update your table name appropriately).

        ```
        aws dynamodb scan --table-name CrossAccountManager-Roles --region eu-west-1 --profile sharedserv --query 'Items[*].{Role:Role.S,AccountGroup:AccountGroup.S,Status:Status.S}' --output table

        ----------------------------------------------------------------
        |                                 Scan                         |
        +--------------+------------------------------------+----------+
        | AccountGroup |                   Role             | Status   |
        +--------------+------------------------------------+----------+
        |  *           |  CrossAccountManager-Administrator |  active  |
        |  *           |  CrossAccountManager-PowerUser     |  active  |
        |  devops      |  CrossAccountManager-DevOps        |  active  |
        |  devops      |  CrossAccountManager-NetworkAdmin  |  active  |
        |  devops      |  CrossAccountManager-DBAdmin       |  active  |
        |  *           |  CrossAccountManager-ReadOnly      |  active  |
        |  billing     |  CrossAccountManager-Billing       |  active  |
        +--------------+------------------------------------+----------+
        ```
    -   Check the list of roles that will be created in corresponding accounts.

        ```
        aws dynamodb scan --table-name CrossAccountManager-Account-Roles --region eu-west-1 --profile sharedserv --query 'Items[*].{AccountId:AccountId.S,Role:Role.S,Status:Status.S}' --output table

        ----------------------------------------------------------------
        |                                 Scan                         |
        +--------------+------------------------------------+----------+
        |   AccountId  |                   Role             | Status   |
        +--------------+------------------------------------+----------+
        |  987654321098|  CrossAccountManager-Administrator |  active  |
        |  654321987098|  CrossAccountManager-Administrator |  active  |
        |  123456789012|  CrossAccountManager-Administrator |  active  |
        |  987654321098|  CrossAccountManager-PowerUser     |  active  |
        |  654321987098|  CrossAccountManager-PowerUser     |  active  |
        |  123456789012|  CrossAccountManager-PowerUser     |  active  |
        |  654321987098|  CrossAccountManager-DevOps        |  active  |
        |  654321987098|  CrossAccountManager-NetworkAdmin  |  active  |
        |  654321987098|  CrossAccountManager-DBAdmin       |  active  |
        |  987654321098|  CrossAccountManager-ReadOnly      |  active  |
        |  654321987098|  CrossAccountManager-ReadOnly      |  active  |
        |  123456789012|  CrossAccountManager-ReadOnly      |  active  |
        |  123456789012|  CrossAccountManager-Billing       |  active  |
        +--------------+------------------------------------+----------+
        ```

## Assign IAM Roles to your Active Directory Groups

1.  Create an Access URL following the instructions in [the documentation](http://docs.aws.amazon.com/directoryservice/latest/admin-guide/access_url.html).

2.  Enable AWS Management Console Access following the instructions in [the documentation](http://docs.aws.amazon.com/directoryservice/latest/admin-guide/aws_console_access.html#console_enable).

3.  Assign IAM Roles created by CrossAccountManager to the ActiveDirectory Groups created for AWS as instructed in [the documentation](http://docs.aws.amazon.com/directoryservice/latest/admin-guide/assign_role.html). (In step 9 of the documentation select on-premises trust)

    Make sure you map the IAM Role & AD Group as per the table below

|IAM Role|Active Directory Group|
|--------|----------------------|
|CrossAccountManager-Administrator|AWS-Administrator|
|CrossAccountManager-PowerUser|AWS-PowerUser|
|CrossAccountManager-DevOps|AWS-DevOps|
|CrossAccountManager-NetworkAdmin|AWS-NetworkAdmin|
|CrossAccountManager-DBAdmin|AWS-DBAdmin|
|CrossAccountManager-ReadOnly|AWS-ReadOnly|
|CrossAccountManager-Billing|AWS-Billing|

## Use the solution webpage to access a sub-account

1.  Append '/console' to the access URL you have created as part of Step 1 of the previous procedure. (e.g. <https://lz-prakash-example.awsapps.com/console/>).

2.  Login using the domain username (e.g. AdminUser) & password (e.g. p@ssw0rd+).

3.  The login screen contains a drop-down field of all roles assigned to your user identity. Select the role you want to use to log in to solution. This role will determine the sub-accounts you can access.

4.  This takes you to the AWS Management Console. Open the Amazon S3 console.

5.  Select the Amazon S3 bucket that hosts the webpage of access links. ('AccessLinksBucket' that you created using CloudFormation in the beginning of this module).

6.  Choose the webpage (cross-account-manager-links.html) to go to the detail page, and choose Open. This will open a webpage that contains access links for all managed accounts.

7.  The webpage links are organized by role. Find the role you used to log in to the console, and choose a link under that role to access an approved sub-account. A window appears with relevant fields already populated.

    > **Note:**
    > The solution webpage will show all sub-accounts that the solution manages, not just the accounts your role(s) has access to. If you try to access a sub-account that is not authorized for your role, the switch role window will show an authorization error.

8.  Choose Switch Role to open the AWS Management Console for that sub-account. The account will switch automatically.
