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

#### Create Security OU
*   Create Security Organizational Units (OU) and name it `Security` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
```
aws organizations create-organizational-unit --region us-east-1 --profile billing --name Security --parent-id r-abcd
```
```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7rqbdtza",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7rqbdtza",
        "Name": "Security"
    }
}
```

> Save the value of Id (e.g. ou-abcd-7rqbdtza) returned by the above command in ResourcesList.txt file.

#### Create Shared Services OU
*   Create Shared Services Organizational Unit (OU) and name it `Shared Services` [following the steps in documentation](http://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_ous.html#create_ou).

**Using CLI:**

*   Use the correct organization ID for parameter `--parent-id` in the below command, create organizational unit.
```
aws organizations create-organizational-unit --region us-east-1 --profile billing --name "Shared Services" --parent-id r-abcd
```
```json
{
    "OrganizationalUnit": {
        "Id": "ou-abcd-7rqbdtza",
        "Arn": "arn:aws:organizations::123456789012:ou/o-got31bf9ah/ou-abcd-7rqbdtza",
        "Name": "Security"
    }
}
```

> Save the value of Id (e.g. ou-abcd-7rqbdtza) returned by the above command in ResourcesList.txt file.


#### Create Applications OU
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
        "Name": "Security"
    }
}
```

> Save the value of Id (e.g. ou-abcd-7rqbdtza) returned by the above command in ResourcesList.txt file.


## Create required AWS accounts

> Each AWS account that you create requires an unique email address. For ease of use, most mail servers ignores the characters after a plus sign `+`. You shall add strings like `+lzsec` to your existing email address to get unique email address, still the mails will get delivered to the same mailbox as the original email.  
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

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    ```
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --email noreply+lzsec@example.com --account-name "Security Account"
    ```
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

4.  Create a new Shared Services account by entering the following details.

    *   Full Name – Enter a name (e.g. Shared Services Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzss@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    ```
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "Shared Services Account" --email noreply+lzss@example.com
    ```
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

4.  Create a new Application One account by entering the following details.

    *   Full Name – Enter a name (e.g. Application One Account)
    *   Email Address – Valid unique email address (e.g. noreply+lzapp1@example.com)
    *   IAM role name – Admin IAM role which the appropriate user in Billing account can assume. Name it **PayerAccountAccessRole** for all the accounts you are creating under the Master account.

    **Using CLI:**

    Update the --email parameter to appropriate email address and run the command. Save the create request id in the 'ResourcesList.txt' file.

    ```
    aws organizations create-account --role-name PayerAccountAccessRole --iam-user-access-to-billing ALLOW --region us-east-1 --profile billing --account-name "Application One Account" --email noreply+lzapp1@example.com
    ```
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
4.  Following the above `Step 3` create another 2 accounts for *Shared Services* and *Application One*.

## Move accounts under corresponding Organizational Units

1.  Navigate to 'Organize Accounts' tab in AWS Organizations console, which will display all the accounts under your organization.

    **Using CLI**  
    Get the 12 digit AWS account Ids of the 'Security', 'Shared Services' and 'Applications' accounts.

    ```
    aws organizations list-accounts --region us-east-1 --profile billing --query 'Accounts[*].{Name:Name,Email:Email,AccountId:Id}' --output table
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
    ```
    $ aws organizations describe-create-account-status --region us-east-1 --profile billing --create-account-request-id car-bb4f1750cdef11e78b08511c66cd64c5
    ```
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

2.  Move 'Security Account', 'Shared Services Account' and 'Application One' accounts to their corresponding OU’s.

    **Using CLI**  
    Find below the example for `Security` account and you should repeat the same steps for `Shared Services` and `Application One` accounts.

    Provide the 12 digit account id of Security account for `--account-id` parameter, provide the ID of the organization (e.g. r-abcd) for `--source-parent-id` parameter and ID of the Security OU (e.g. ou-abcd-7rqbdtza) for `--destination-parent-id`.

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
    |  noreply+lzsec@example.com   |  987654321098 |  Security Account         |  ACTIVE |
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
