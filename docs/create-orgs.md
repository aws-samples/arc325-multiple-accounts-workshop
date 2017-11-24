Create AWS Organization, Organizational Units under them. Then create sub accounts for Security, Shared Services, Applications, etc. and map them under appropriate OU’s.

> *   Use **North Virginia (us-east-1)** region in billing account.
>
> *   Use **Ireland (eu-west-1)** to create all resources in sub accounts.

**Table of Contents:**
-   [Create Organization and Organizational Units in the billing account](#create-organization-and-organizational-units-in-the-billing-account)
    -   [Create Organization](#create-organization)
    -   [Create Organizational Units (OUs)](#create-organizational-units-ous)
        -   [Create Security OU](#create-security-ou)
        -   [Create Shared Services OU](#create-shared-services-ou)
        -   [Create Applications OU](#create-applications-ou)
-   [Create required AWS accounts](#create-required-aws-accounts)
-   [Move accounts under corresponding Organizational Units](#move-accounts-under-corresponding-organizational-units)
    -   [Move 'Security Account' to 'Security OU'.](#move-security-account-to-security-ou)
    -   [Move 'Shared Services Account' to 'Shared Services OU'.](#move-shared-services-account-to-shared-services-ou)
    -   [Move 'Application One Account' to 'Applications OU'.](#move-application-one-account-to-applications-ou)
-   [Configure CLI for Cross Account access through Assume Role (only if you are using CLI)](#configure-cli-for-cross-account-access-through-assume-role-only-if-you-are-using-cli)


## Create Organization and Organizational Units in the billing account

Login to your [AWS Management Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1) and navigate to [AWS Organizations](https://console.aws.amazon.com/organizations/home) console.

### Create Organization

Create an Organization. This account will be your Billing account and you will create additional account under this account.

**Using CLI:**
```
aws organizations create-organization --feature-set ALL --region us-east-1 --profile billing
```
```json
{
    "Organization": {
        "AvailablePolicyTypes": [
            {
                "Status": "ENABLED",
                "Type": "SERVICE_CONTROL_POLICY"
            }
        ],
        "MasterAccountId": "123456789012",
        "MasterAccountArn": "arn:aws:organizations::123456789012:account/o-got31bf9ah/123456789012",
        "FeatureSet": "ALL",
        "MasterAccountEmail": "noreply+lzbilling@example.com",
        "Id": "o-got31bf9ah",
        "Arn": "arn:aws:organizations::123456789012:organization/o-got31bf9ah"
    }
}
```

Get the ID of the organization and save it in `ResourcesList.txt`

<code style=display:block;white-space:pre-wrap>
aws organizations list-roots --region us-east-1 --profile billing --query 'Roots[0].Id'
<b><i><u>"r-abcd"</u></i></b>
</code>

### Create Organizational Units (OUs)

#### Create Security OU
*   Create Security Organizational Units (OU) and name it `Security` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.

<code style=display:block;white-space:pre-wrap>aws organizations create-organizational-unit --region us-east-1 --profile billing --name Security --parent-id <b><i><u>r-abcd</u></i></b>
</code>

```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7example",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7example",
        "Name": "Security"
    }
}
```

> Save the value of Security OU Id (e.g. ou-abcd-7example) returned by the above command or from the UI in ResourcesList.txt file.

#### Create Shared Services OU
*   Create Shared Services Organizational Unit (OU) and name it `Shared Services` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
<code style=display:block;white-space:pre-wrap>
aws organizations create-organizational-unit --region us-east-1 --profile billing --name "Shared Services" --parent-id <b><i><u>r-abcd</u></i></b>
</code>

```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7example",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7example",
        "Name": "Shared Services"
    }
}
```

> Save the value of Shared Services OU Id (e.g. ou-abcd-7example) returned by the above command or from the UI in ResourcesList.txt file.


#### Create Applications OU
*   Create Applications Organizational Unit (OU) and name it `Applications` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
<code style=display:block;white-space:pre-wrap>
aws organizations create-organizational-unit --region us-east-1 --profile billing --name Applications --parent-id <b><i><u>r-abcd</u></i></b>
</code>

```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7example",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7example",
        "Name": "Applications"
    }
}
```

> Save the value of Applications OU Id (e.g. ou-abcd-7example) returned by the above command or from the UI in ResourcesList.txt file.


## Create required AWS accounts

> Each AWS account that you create requires an unique email address. For ease of use, most mail servers ignores the characters after a plus sign `+`. You shall add strings like `+lzsec` to your existing email address to get unique email address, still the mails will get delivered to the same mailbox as the original email.  
>   
> E.g. If your email address is `noreply@example.com`, you shall use `noreply+lzsec@example.com` while creating the account and it will deliver the emails to `noreply@example.com` mailbox.  
>   
> Check whether your mail server supports this capability by sending a test email. If it doesn’t support this capability then you need to create unique email address for each account that you are creating.

### Create Security Account
1.  Navigate to Accounts tab of AWS Organizations console.

2.  Click ‘Add Account’ followed by [‘Create Account’](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html).

3.  Create a new security account by entering the following details.

    *   Full Name – Enter a name (e.g. Security Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzsec@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    <code style=display:block;white-space:pre-wrap>aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "Security Account" --email <b><i><u>noreply+lzsec@example.com</u></i></b>
    </code>

    ```json
    {
        "CreateAccountStatus": {
            "RequestedTimestamp": 1508943783.375,
            "State": "IN_PROGRESS",
            "Id": "car-77558640b99511e78c88511c44cd49c5",
            "AccountName": "Security Account"
        }
    }
    ```

    > Save the value of Create Account Request Id (e.g. car-77558640b99511e78c88511c44cd49c5) returned by the above command in ResourcesList.txt file to check the status if needed.

### Create Shared Services Account
1.  Click ‘Add Account’ followed by [‘Create Account’](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html).

2.  Create a new Shared Services account by entering the following details.

    *   Full Name – Enter a name (e.g. Shared Services Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzss@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    <code style=display:block;white-space:pre-wrap>
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "Shared Services Account" --email <b><i><u>noreply+lzss@example.com</u></i></b>
    </code>

    ```json
    {
        "CreateAccountStatus": {
            "RequestedTimestamp": 1508943783.375,
            "State": "IN_PROGRESS",
            "Id": "car-77558640b99511e78c88511c44cd49c5",
            "AccountName": "Shared Services Account"
        }
    }
    ```
    > Save the value of Create Account Request Id (e.g. car-77558640b99511e78c88511c44cd49c5) returned by the above command in ResourcesList.txt file to check the status if needed.

### Create Application One Account
1.  Click ‘Add Account’ followed by [‘Create Account’](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html).

2.  Create a new Application One account by entering the following details.

    *   Full Name – Enter a name (e.g. Application One Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzapp1@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    <code style=display:block;white-space:pre-wrap>
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "Application One Account" --email <b><i><u>noreply+lzapp1@example.com</u></i></b>
    </code>

    ```json
    {
        "CreateAccountStatus": {
            "RequestedTimestamp": 1508943783.375,
            "State": "IN_PROGRESS",
            "Id": "car-77558640b99511e78c88511c44cd49c5",
            "AccountName": "Shared Services Account"
        }
    }
    ```
    > Save the value of Create Account Request Id (e.g. car-77558640b99511e78c88511c44cd49c5) returned by the above command in ResourcesList.txt file to check the status if needed.

## Move accounts under corresponding Organizational Units

Navigate to 'Organize Accounts' tab in AWS Organizations console, which will display all the accounts under your organization.

**Using CLI**  
Get the 12 digit AWS account Ids of the 'Security', 'Shared Services' and 'Applications' accounts.

```
aws organizations list-accounts --region us-east-1 --profile billing --query 'Accounts[*].{Name:Name,Email:Email,AccountId:Id}' --output table
```

```
----------------------------------------------------------------------------
|                               ListAccounts                               |
+--------------+-------------------------------+---------------------------+
|   AccountId  |             Email             |           Name            |
+--------------+-------------------------------+---------------------------+
|  123456789012|  noreply+billing@example.com  |  Billing Account          |
|  321098987654|  noreply+lzss@example.com     |  Shared Services Account  |
|  654321987098|  noreply+lzapp1@example.com   |  Application One Account  |
|  987654321098|  noreply+lzsec@example.com    |  Security Account         |
+--------------+-------------------------------+---------------------------+
```

If any of the accounts are missing, check the status of create account request using the following command by providing the correct creation request id for `--create-account-request-id` parameter and check the 'FailureReason' to fix it.
<code>
$ aws organizations describe-create-account-status --region us-east-1 --profile billing --create-account-request-id <b><i><u>car-bb4f1750cdef11e78b08511c66cd64c5</u></i></b>
</code>

```json
{
    "CreateAccountStatus": {
        "AccountName": "Shared Services Account",
        "State": "FAILED",
        "RequestedTimestamp": 1511181518.779,
        "FailureReason": "EMAIL_ALREADY_EXISTS",
        "Id": "car-bb4f1750cdef11e78b08500c66cd64c5",
        "CompletedTimestamp": 1511181519.137
    }
}
```

### Move 'Security Account' to 'Security OU'.

Select the Security Account in the console and move it to Security OU as explained in [the documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#move_account_to_ou).

**Using CLI**

Provide the 12 digit account id of Security account for `--account-id` parameter, provide the ID of the organization (e.g. r-abcd) for `--source-parent-id` parameter and ID of the Security OU (e.g. ou-abcd-7example) for `--destination-parent-id`.

<code>
aws organizations move-account --region us-east-1 --profile billing --source-parent-id <b><i><u>r-abcd</u></i></b> --destination-parent-id <b><i><u>ou-abcd-7example</u></i></b> --account-id <b><i><u>987654321098</u></i></b>
</code>

Check whether the account got moved successfully.

<code>
aws organizations list-accounts-for-parent --region us-east-1 --profile billing --query 'Accounts[&#42;].{Name:Name,Email:Email,Id:Id,Status:Status}' --output table --parent-id <b><i><u>ou-abcd-7example</u></i></b>
</code>

```
--------------------------------------------------------------------------------------
|                                ListAccountsForParent                               |
+------------------------------+---------------+---------------------------+---------+
|             Email            |      Id       |           Name            | Status  |
+------------------------------+---------------+---------------------------+---------+
|  noreply+lzsec@example.com   |  987654321098 |  Security Account         |  ACTIVE |
+------------------------------+---------------+---------------------------+---------+
```

### Move 'Shared Services Account' to 'Shared Services OU'.

Select the Shared Services Account in the console and move it to Shared Services OU as explained in [the documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#move_account_to_ou).

**Using CLI**

Provide the 12 digit account id of Shared Services account for `--account-id` parameter, provide the ID of the organization (e.g. r-abcd) for `--source-parent-id` parameter and ID of the Shared Services OU (e.g. ou-abcd-7example) for `--destination-parent-id`.

<code>
aws organizations move-account --region us-east-1 --profile billing --source-parent-id <b><i><u>r-abcd</u></i></b> --destination-parent-id <b><i><u>ou-abcd-7example</u></i></b> --account-id <b><i><u>321098987654</u></i></b>
</code>

Check whether the account got moved successfully.

<code>
aws organizations list-accounts-for-parent --region us-east-1 --profile billing --query 'Accounts[&#42;].{Name:Name,Email:Email,Id:Id,Status:Status}' --output table --parent-id <b><i><u>ou-abcd-7example</u></i></b>
</code>

```
--------------------------------------------------------------------------------------
|                                ListAccountsForParent                               |
+------------------------------+---------------+---------------------------+---------+
|             Email            |      Id       |           Name            | Status  |
+------------------------------+---------------+---------------------------+---------+
|  noreply+lzss@example.com    |  321098987654 |  Shared Service Account   |  ACTIVE |
+------------------------------+---------------+---------------------------+---------+
```

### Move 'Application One Account' to 'Applications OU'.

Select the Application One Account in the console and move it to Applications OU as explained in [the documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#move_account_to_ou).


**Using CLI**

Provide the 12 digit account id of Application One account for `--account-id` parameter, provide the ID of the organization (e.g. r-abcd) for `--source-parent-id` parameter and ID of the Application One OU (e.g. ou-abcd-7example) for `--destination-parent-id`.

<code>
aws organizations move-account --region us-east-1 --profile billing --source-parent-id <b><i><u>r-abcd</u></i></b> --destination-parent-id <b><i><u>ou-abcd-7example</u></i></b> --account-id <b><i><u>654321987098</u></i></b>
</code>

Check whether the account got moved successfully.

<code>
aws organizations list-accounts-for-parent --region us-east-1 --profile billing --query 'Accounts[&#42;].{Name:Name,Email:Email,Id:Id,Status:Status}' --output table --parent-id <b><i><u>ou-abcd-7example</u></i></b>
</code>

```
--------------------------------------------------------------------------------------
|                                ListAccountsForParent                               |
+------------------------------+---------------+---------------------------+---------+
|             Email            |      Id       |           Name            | Status  |
+------------------------------+---------------+---------------------------+---------+
|  noreply+lzapp1@example.com  |  654321987098 | Application One Account   |  ACTIVE |
+------------------------------+---------------+---------------------------+---------+
```

## Configure CLI for Cross Account access through Assume Role (only if you are using CLI)

Update the AWS CLI configuration file `~/.aws/config` in your workstation with the details of all the 3 accounts to perform [cross account assume role](http://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html) using the ARN of the role (`PayerAccountAccessRole`) created in each account.

*Example:*

```
~/.aws/config
[profile billing]
region=us-east-1
output=json

[profile security]
role_arn = arn:aws:iam::987654321098:role/PayerAccountAccessRole
source_profile = billing
region=eu-west-1
output=json

[profile sharedserv]
role_arn = arn:aws:iam::321098987654:role/PayerAccountAccessRole
source_profile = billing
region=eu-west-1
output=json

[profile appone]
role_arn = arn:aws:iam::654321987098:role/PayerAccountAccessRole
source_profile = billing
region=eu-west-1
output=json
```

You shall use the above snippet and update the appropriate Account ID in the role_arn.
