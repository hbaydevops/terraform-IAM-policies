#!/bin/bash

# Variables
ROLE_ARN="arn:aws:iam::490004630776:role/webforx-policy-tester-02"
SESSION_NAME="WebforxTestSession"

# Assume the role
echo "Assuming role: $ROLE_ARN"
CREDS=$(aws sts assume-role \
  --role-arn "$ROLE_ARN" \
  --role-session-name "$SESSION_NAME" \
  --duration-seconds 3600 \
  --output json)

if [ $? -ne 0 ]; then
  echo "Error assuming role. Exiting."
  exit 1
fi

# Extract temporary credentials
export AWS_ACCESS_KEY_ID=$(echo $CREDS | jq -r '.Credentials.AccessKeyId')
export AWS_SECRET_ACCESS_KEY=$(echo $CREDS | jq -r '.Credentials.SecretAccessKey')
export AWS_SESSION_TOKEN=$(echo $CREDS | jq -r '.Credentials.SessionToken')

echo "Temporary credentials set. Running tests..."

# Test 1: List S3 buckets (us-east-1) - SHOULD SUCCEED
echo -e "\n[TEST 1] List S3 Buckets (us-east-1)"
aws s3 ls --region us-east-1

# Test 2: List S3 buckets (us-west-2) - SHOULD FAIL (region restriction)
echo -e "\n[TEST 2] List S3 Buckets (us-west-2)"
aws s3 ls --region us-west-2

# Test 3: Describe EC2 (us-east-1) - SHOULD SUCCEED
echo -e "\n[TEST 3] Describe EC2 (us-east-1)"
aws ec2 describe-instances --region us-east-1

# Test 4: Run t2.micro in us-east-2 - SHOULD FAIL (region restriction + tag check)
echo -e "\n[TEST 4] Run t2.micro EC2 in us-east-2"
aws ec2 run-instances \
  --image-id ami-12345678 \
  --instance-type t2.micro \
  --min-count 1 --max-count 1 \
  --region us-east-2 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=test}]'

# Test 5: Run m5.large in us-east-1 - SHOULD FAIL (instance type not explicitly denied, but may fail due to missing tag or naming)
echo -e "\n[TEST 5] Run m5.large EC2 in us-east-1"
aws ec2 run-instances \
  --image-id ami-12345678 \
  --instance-type m5.large \
  --min-count 1 --max-count 1 \
  --region us-east-1 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=webforx-test}]'

# Test 6: Create EBS volume (gp2) - SHOULD FAIL (only gp3 allowed)
echo -e "\n[TEST 6] Create EBS volume with gp2"
aws ec2 create-volume \
  --availability-zone us-east-1a \
  --size 10 \
  --volume-type gp2 \
  --region us-east-1

# Test 7: Create EBS volume (gp3) with size 40 - SHOULD FAIL (limit is 30)
echo -e "\n[TEST 7] Create gp3 EBS volume of size 40"
aws ec2 create-volume \
  --availability-zone us-east-1a \
  --size 40 \
  --volume-type gp3 \
  --region us-east-1

# Test 8: Create RDS instance (MySQL, 40 GiB) - SHOULD FAIL (size > 30)
echo -e "\n[TEST 8] Create RDS MySQL with 40GiB"
aws rds create-db-instance \
  --db-instance-identifier test-db1 \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --allocated-storage 40 \
  --master-username admin \
  --master-user-password Password123! \
  --region us-east-1

# Test 9: Create RDS (MSSQL) in us-east-1 - SHOULD FAIL (not mysql/postgres)
echo -e "\n[TEST 9] Create RDS MSSQL"
aws rds create-db-instance \
  --db-instance-identifier test-db2 \
  --db-instance-class db.t3.micro \
  --engine sqlserver-ex \
  --allocated-storage 20 \
  --master-username admin \
  --master-user-password Password123! \
  --region us-east-1

# Test 10: Create Bare Metal EC2 instance - SHOULD FAIL (metal instance type)
echo -e "\n[TEST 10] Run metal EC2 instance"
aws ec2 run-instances \
  --image-id ami-12345678 \
  --instance-type m5.metal \
  --min-count 1 --max-count 1 \
  --region us-east-1 \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=webforx-metal}]'

# Test 11: Create IAM Group - SHOULD FAIL (explicit deny)
echo -e "\n[TEST 11] Create IAM Group"
aws iam create-group --group-name test-group-fail

# # Cleanup
# unset AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN

echo -e "\nTest complete."


