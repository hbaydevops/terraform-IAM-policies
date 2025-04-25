📌 feature/<TICKET NUMBER>-<USERNAME>-<TICKET NAME>

📝 Example: feature/45-s20test.wft-updating-ansible-patches-role

TERRAFORM_VERSION="1.10.5"

********** change AWS account ID in test-role.tf *************
********** uncomment outputs.tf ************

________________________________________________________________________________
Run this command in your terminal to initialize the role:

aws sts assume-role \
  --role-arn arn:aws:iam::490004630776:role/webforx-policy-tester \
  --role-session-name "WebforxTestSession"


Then export the temporary credentials:

export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export AWS_SESSION_TOKEN=...

Once you've run the aws sts assume-role command and obtained temporary credentials, you can verify that the assumed role is active by running the following command:

aws sts get-caller-identity


command to run the bash script:

bash webforx-policy-test.sh



scp_restrictions.tf (if using AWS Organizations)

🔐 Permission boundaries restrict IAM capabilities per user/role

🌍 SCPs (Service Control Policy) enforce region and naming constraints org-wide

🧾 Tags and tag-based conditions help enforce naming conventions

SCP stands for Service Control Policy.

It’s a feature in AWS Organizations that lets you define the maximum permissions an AWS account or Organizational Unit (OU) can have.

Think of it like a "guardrail":
Even if a user or role in the account has an IAM policy that allows something, an SCP can override that and deny it.

🔐 SCP vs IAM Policy

                           SCP (Service Control Policy)	         IAM Policy
Scope	                   Account/OU level	                     User, Group, or Role level
Can grant permissions?	   ❌ No — only limits	               ✅ Yes
Can deny permissions?	   ✅ Yes	                           ✅ Yes
Used for	               Organizational governance	         Identity-specific access control