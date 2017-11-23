Here are the pre-requisites for the Managing multiple AWS accounts at scale workshop:

**Table of Contents:**
-   [Clone the repo](#clone-the-repo)
-   [AWS Account](#aws-account)
-   [AWS CLI](#aws-cli)
    -   [Setup on macOS](#setup-on-macos)
    -   [Setup on Windows](#setup-on-windows)
    -   [Setup on Linux](#setup-on-linux)
-   [AWS IAM Permissions](#aws-iam-permissions)
    -   [Create admin user and group](#create-admin-user-and-group)
    -   [Create a Key Pair](#create-a-key-pair)
-   [Remote Desktop Client](#remote-desktop-client)
    -   [Setup on macOS](#setup-on-macos-1)
    -   [Setup on Windows](#setup-on-windows-1)
    -   [Setup on Linux](#setup-on-linux-1)
-   [Resource List files (Highly Recommended)](#resource-list-files-highly-recommended)



## Clone the repo
The workshop repo has AWS CloudFormation templates and configuration files to create and configure various resources. You need to clone the repo to have access to those files:

```
$ git clone <name-of-the-repo>
```

## AWS Account
You will be using an AWS Account while you go through the workshop. [Create an AWS Account](https://aws.amazon.com/free/) if you don’t already have one.

## AWS CLI
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

## Resource List files (Highly Recommended)

Inside the repo that you cloned, there is a file named `ResourcesList.txt`. You shall use that file to store the value of the resources that you are going to create during every module. It will be easy to cross reference from that file whenever needed.

## AWS IAM Permissions
If you already have an AWS Account, you need to create an IAM user to use during the workshop. If you have not created an IAM admin user and group yet, please do so in the following section. If you already have admin user then skip to Create IAM user for workshop.

### Create admin user and group
Please go to [IAM Console](https://console.aws.amazon.com/iam/home#/users) and click on `Add user`. As a username choose Administrator, select the *Programmatic access* and *AWS Management Console access* checkboxes and hit `Next: Permissions`.

In the next dialog select Create group, name it Administrators, select the AdministratorAccess policy and click Create group.

Finally click Next: Review and Create user in the final dialog.

Now you see your newly admin user and group together with the Access key ID. To see the Secret access key once, click on Show next to the stars. Note everything down: those info are needed alter on.

Using the Access Key ID & Secret Access Key obtained from the above step configure a [Named Profile](http://docs.aws.amazon.com/cli/latest/userguide/cli-multiple-profiles.html) and name it according to the function you have in your team changing the <PUT_YOUR_PROFILE_NAME_HERE> placeholder .

*Example:*
```
aws configure --profile billing
AWS Access Key ID [None]: AKIAI44QH8DHBEXAMPLE
AWS Secret Access Key [None]: je7MtGbClwBF/2Zp9Utk/h3yCo8nvbEXAMPLEKEY
Default region name [None]: us-east-1
Default output format [None]: json
```

### Create a Key Pair
[Create a Key Pair using Amazon EC2](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-key-pairs.html#having-ec2-create-your-key-pair) and store it securely. It will be needed during the lab.

Or create the key pair [using CLI](http://docs.aws.amazon.com/cli/latest/userguide/cli-ec2-keypairs.html) and store the returned KeyMaterial securely.

***example linux:***
```bash
$ aws ec2 create-key-pair --profile billing --key-name lz-billing-kp-us-east-1 --query 'KeyMaterial' --output text > lz-billing-kp-us-east-1.pem
```

***example windows:***
```shell
aws ec2 create-key-pair --profile billing --key-name lz-billing-kp-us-east-1 --query 'KeyMaterial' --output text | out-file -encoding ascii -filepath lz-billing-kp-us-east-1.pem
```

## Remote Desktop Client
You need RDP client to connect to the Active Directory Domain Controller and Directory Service Remote Desktop Gateway.

### Setup on macOS
-   <https://docs.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-mac>

### Setup on Windows
-   In the search box on the taskbar, type Remote Desktop Connection, and then select Remote Desktop Connection.

### Setup on Linux
-   Remmina - <http://www.remmina.org/wp/>
