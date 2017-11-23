Create AWS Organization, Organizational Units under them. Then create sub accounts for Security, Shared Services, Applications, etc. and map them under appropriate OU’s.

> *   Use **North Virginia (us-east-1)** region in billing account.
>
> *   Use **Ireland (eu-west-1)** to create all resources in sub accounts.

**Table of Contents:**
-   [Create Organization and Organizational Units in the billing account](#create-organization-and-organizational-units-in-the-billing-account)
-   [Create required AWS accounts](#create-required-aws-accounts)
-   [Move accounts under corresponding Organizational Units](#move-accounts-under-corresponding-organizational-units)
-   [Configure Cross Account access through Assume Role](#configure-cross-account-access-through-assume-role)


## Create Organization and Organizational Units in the billing account

Login to your [AWS Management Console](https://us-east-1.console.aws.amazon.com/console/home?region=us-east-1) and navigate to [AWS Organizations](https://console.aws.amazon.com/organizations/home) console.

### Create Organization

Create an Organization if it doesn’t exist already. This account will be your Billing account and you will create additional account under this account.

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

```
aws organizations list-roots --region us-east-1 --profile billing --query 'Roots[0].Id'

"r-abcd"
```

### Create Organizational Units (OUs)

#### Create WorkShop OU
*   Create WorkShop Organizational Units (OU) and name it `WorkShop` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
```
aws organizations create-organizational-unit --region us-east-1 --profile billing --name WorkShop --parent-id r-abcd
```
```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7rqbdtza",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7rqbdtza",
        "Name": "WorkShop"
    }
}
```

> Save the value of Id (e.g. ou-abcd-7rqbdtza) returned by the above command in ResourcesList.txt file.

#### Create Applications OU

***This step is optional: depend if you own another account that can be onboarded later on***

*   Create Applications Organizational Unit (OU) and name it `Applications` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
```
aws organizations create-organizational-unit --region us-east-1 --profile billing --name Applications --parent-id r-abcd
```
```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7rqbdtza",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7rqbdtza",
        "Name": "Applications"
    }
}
```

> Save the value of Id (e.g. ou-abcd-7rqbdtza) returned by the above command in ResourcesList.txt file.


## Create required AWS account

> The AWS account that you create requires an unique email address. For ease of use, most mail servers ignores the characters after a plus sign `+`. You shall add strings like `+workshop` to your existing email address to get unique email address, still the mails will get delivered to the same mailbox as the original email.  
>   
> E.g. If your email address is `noreply@example.com`, you shall use `noreply+lzsec@example.com` while creating the account and it will deliver the emails to `noreply@example.com` mailbox.  
>   
> Check whether your mail server supports this capability by sending a test email. If it doesn’t support this capability then you need to create unique email address for each account that you are creating.

1.  Navigate to Accounts tab of AWS Organizations console.

2.  Click ‘Add Account’ followed by [‘Create Account’](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_create.html).

3.  Create a new security account by entering the following details.

    *   Full Name – Enter a name (e.g. Security Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzsec@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the ```--email``` parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    ```
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "WorkShop Account" --email noreply+lzsec@example.com
    ```
    ```json
    {
        "CreateAccountStatus": {
            "RequestedTimestamp": 1508943783.375,
            "State": "IN_PROGRESS",
            "Id": "car-77558640b99511e78c88511c44cd49c5",
            "AccountName": "WorkShop Account"
        }
    }
    ```

## Move the account under corresponding Organizational Unit

1.  Navigate to 'Organize Accounts' tab in AWS Organizations console, which will display all the accounts under your organization.

    **Using CLI**  
    Get the 12 digit AWS account Id of the 'WorkShop' account.

    ```
    aws organizations list-accounts --region us-east-1 --profile billing --query 'Accounts[*].{Name:Name,Email:Email,AccountId:Id}' --output table
    ----------------------------------------------------------------------------
    |                               ListAccounts                               |
    +--------------+-------------------------------+---------------------------+
    |   AccountId  |             Email             |           Name            |
    +--------------+-------------------------------+---------------------------+
    |  123456789012|  noreply+billing@example.com  |  Billing Account          |
    |  321098987654|  noreply+lzss@example.com     |  WorkShop Account         |
    +--------------+-------------------------------+---------------------------+
    ```

    If the account is still missing, check the status of create account request using the following command by providing the correct creation request id for `--create-account-request-id` parameter and check the 'FailureReason' to fix it.
    ```
    $ aws organizations describe-create-account-status --region us-east-1 --profile billing --create-account-request-id car-bb4f1750cdef11e78b08511c66cd64c5
    ```
    ```json
    {
        "CreateAccountStatus": {
            "AccountName": "WorkShop Account",
            "State": "FAILED",
            "RequestedTimestamp": 1511181518.779,
            "FailureReason": "EMAIL_ALREADY_EXISTS",
            "Id": "car-bb4f1750cdef11e78b08500c66cd64c5",
            "CompletedTimestamp": 1511181519.137
        }
    }
    ```

2.  Move 'WorkShop' account to its corresponding OU.

    **Using CLI**  

    Provide the 12 digit account id of WorkShop account for `--account-id` parameter, provide the ID of the organization (e.g. r-abcd) for `--source-parent-id` parameter and ID of the WorkShop OU (e.g. ou-abcd-7rqbdtza) for `--destination-parent-id`.

    ```
    aws organizations move-account --region us-east-1 --profile billing --source-parent-id r-abcd --destination-parent-id ou-abcd-7rqbdtza --account-id 987654321098
    ```

    Check whether the account got moved successfully.
    ```
    aws organizations list-accounts-for-parent --region us-east-1 --profile billing --query 'Accounts[*].{Name:Name,Email:Email,Id:Id,Status:Status}' --output table --parent-id ou-abcd-7rqbdtza

    --------------------------------------------------------------------------------------
    |                                ListAccountsForParent                               |
    +------------------------------+---------------+---------------------------+---------+
    |             Email            |      Id       |           Name            | Status  |
    +------------------------------+---------------+---------------------------+---------+
    |  noreply+lzsec@example.com   |  987654321098 |  WorkShop Account         |  ACTIVE |
    +------------------------------+---------------+---------------------------+---------+
    ```

## Configure Cross Account access through Assume Role

Update the AWS CLI configuration file `~/.aws/config` in your workstation with the details of all the 3 accounts to perform [cross account assume role](http://docs.aws.amazon.com/cli/latest/userguide/cli-roles.html) using the ARN of the role (`PayerAccountAccessRole`) created in each account.

*Example:*

```
~/.aws/config
[profile billing]
region=us-east-1
output=json

[profile workshop]
role_arn = arn:aws:iam::<workshop-account-id>:role/PayerAccountAccessRole
source_profile = billing
region=eu-west-1
output=json
```

You shall use the above snippet and update the appropriate Account ID in the role_arn.
