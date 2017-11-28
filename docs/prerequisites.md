Pre-requisites for the Managing multiple AWS accounts at scale workshop.

**Table of Contents:**
-   [Working as a Team](#working-as-a-team)
-   [Clone the repo](#clone-the-repo)
-   [AWS Account](#aws-account)
-   [Generating Access Key ID and Secret Access Key](#generating-access-key-id-and-secret-access-key)
-   [AWS CLI (if you will be using CLI)](#aws-cli-if-you-will-be-using-cli)
    -   [Setup on macOS](#setup-on-macos)
    -   [Setup on Windows](#setup-on-windows)
    -   [Setup on Linux](#setup-on-linux)
    -   [Configure CLI profile](#configure-cli-profile)
-   [Remote Desktop Client](#remote-desktop-client)
    -   [Setup on macOS](#setup-on-macos-1)
    -   [Setup on Windows](#setup-on-windows-1)
    -   [Setup on Linux](#setup-on-linux-1)
-   [Resource List files (Highly Recommended)](#resource-list-files-highly-recommended)


## Working as a Team
Form a team with 3 people in your table. You will be working together to complete the modules. All the steps can be performed only once (e.g. Creating an Organization, etc.), hence decide and share the ownership of a specific module among yourself (or the way that you want to execute as a team).


## Clone the repo
The workshop repo has AWS CloudFormation templates and configuration files to create and configure various resources.

If you have a git client installed, you shall clone the repo to have access to those files:

```
$ git clone https://github.com/aws-samples/arc325-multiple-accounts-workshop.git
```

Else download the zip file from the following URL
```
https://github.com/aws-samples/arc325-multiple-accounts-workshop/archive/master.zip
```

## AWS Account
You will be using the AWS Account provided to you at your table for creating the Organization and subsequent accounts.

At your table, you will have a sheet with URL to signin to your AWS account. It will also include credentials for 6 Lab users, each of you shall use one of the LabUser credentials to login to the AWS console.

The 12 digit number in your Management Console URL will be the AWS Account ID of billing account.


## Generating Access Key ID and Secret Access Key

If you are going to do the lab using programmatically (CLI or API) then you need to create a Access Key for your user [following the instructions in the documentation](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_access-keys.html#Using_CreateAccessKey).


## AWS CLI (if you will be using CLI)
Install the latest version of [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-bundle.html) on your machine.

If you have `pip` or `pip3` installed in your machine you shall install AWS CLI using pip.
```
pip3 install awscli --upgrade --user
```
or
```
pip install awscli --upgrade --user
```
### Setup on macOS
-   <http://docs.aws.amazon.com/cli/latest/userguide/cli-install-macos.html>

### Setup on Windows
-   <http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-windows.html>

### Setup on Linux
-   <http://docs.aws.amazon.com/cli/latest/userguide/awscli-install-linux.html>


### Configure CLI profile

Using the Access Key ID & Secret Access Key obtained from the earlier step configure a [Named Profile](http://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) and name it `billing`.

*Example:*
```
aws configure --profile billing
AWS Access Key ID [None]: AKIAI44QH8DHBEXAMPLE
AWS Secret Access Key [None]: je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

## Remote Desktop Client
You need RDP client to connect to the Active Directory Domain Controller and Directory Service Remote Desktop Gateway.

### Setup on macOS
-   <https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-mac>

### Setup on Windows
-   In the search box on the taskbar, type Remote Desktop Connection, and then select Remote Desktop Connection.

### Setup on Linux
-   Remmina - <http://www.remmina.org/wp/>


## Resource List files (Highly Recommended)

Inside the repo that you cloned, there is a file named `ResourcesList.txt`. You shall use that file to store the value of the resources that you create during every module. It will be easy to cross reference from that file whenever needed.
