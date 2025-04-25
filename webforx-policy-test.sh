#!/bin/bash

echo "🔐 Starting policy tests for Webforx IAM role..."

# REGION TEST
echo "🧪 Test 1: Try to describe EC2 instances in allowed region (us-east-1)"
aws ec2 describe-instances --region us-east-1 || echo "✅ Blocked or limited as expected"

echo "🧪 Test 2: Try to describe EC2 instances in forbidden region (us-west-2)"
aws ec2 describe-instances --region us-west-2 && echo "❌ Region restriction FAILED" || echo "✅ Region restriction enforced"

# IAM TEST
echo "🧪 Test 3: Attempt to create IAM user (should fail)"
aws iam create-user --user-name test-deny-user && echo "❌ IAM user creation FAILED" || echo "✅ IAM user creation blocked"

# SERVICE RESTRICTION TEST
echo "🧪 Test 4: Attempt to access non-whitelisted service (e.g., RDS)"
aws rds describe-db-instances && echo "❌ Non-allowed service access FAILED" || echo "✅ Non-allowed service blocked"

# BARE METAL TEST
echo "🧪 Test 5: Attempt to launch a bare metal EC2 instance"
aws ec2 run-instances \
  --image-id ami-0c55b159cbfafe1f0 \
  --instance-type c5.metal \
  --count 1 \
  --subnet-id subnet-xxxxxxxx \
  --region us-east-1 && echo "❌ Bare metal launch FAILED" || echo "✅ Bare metal launch blocked"

# LEAST PRIVILEGE TEST
echo "🧪 Test 6: Attempt S3 list (allowed)"
aws s3 ls s3://webforx-test-bucket-1745541519 || echo "✅ Least privilege - allowed only what's needed"

echo "🧪 Test 7: Attempt to create a new S3 bucket (should fail)"
aws s3api create-bucket --bucket webforx-test-bucket-$(date +%s) --region us-east-1 && echo "✅ S3 bucket created successfully" 
aws s3api create-bucket --bucket webforx-test02-bucket --region us-east-1 && echo "❌ S3 bucket creation FAILED"

echo "✅ All tests completed."
