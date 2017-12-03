This workshop is designed for Architects, Developers and System Engineers who would like to design, build and manage multiple AWS accounts.

This workshop explains how to manage multiple AWS accounts following best practices using existing quick start guides and solutions.

Modules|DependsOn|Expected Time
-------|---------|-------------
[Prerequisites](docs/prerequisites.md)|N/A|5 Minutes
[Create AWS Organization and sub accounts](docs/create-orgs.md)|Prerequisites|10 Minutes
[Prepare accounts for CloudFormation StackSet](docs/cfn-stackset-prepare.md)|Create AWS Organization and sub accounts|10 Minutes
[Configure Config and CloudTrail on all accounts](docs/security-baseline.md)|Prepare accounts for CloudFormation StackSet|15 Minutes
[Create Active Directory for SSO](docs/lz-ad-sso.md)|Prepare accounts for CloudFormation StackSet|5 Minutes
[Configure Centralized Logging](docs/centralized-logging.md)|Configure Config and CloudTrail on all accounts|5 Minutes  
[Configure trust relationship between AD on EC2 and AD on DS](docs/configure-trust-relationship.md)|Create Active Directory for SSO|15 Minutes
[Deploy and Configure Cross Account Manager](docs/cross-account-manager.md)|Configure trust relationship between AD on EC2 and AD on DS|20 Minutes
[Enable and configure VPC Flow logs](docs/configure-vpc-flow-logs.md) (Optional)|Configure Centralized Logging|10 Minutes
[Configure Logging Dashboard](docs/configure-logging-dashboard.md) (Optional)|Configure Centralized Logging and Enable and configure VPC Flow logs (if you want to have VPC Flow log dashboard)|5 Minutes
[On-board a new account](docs/on-board-new-account.md) (Optional)|Deploy and Configure Cross Account Manager|15 Minutes
[Using Service Control Policies](docs/apply-scp-ou.md) (Optional)|Create AWS Organization and sub accounts|10 Minutes  
