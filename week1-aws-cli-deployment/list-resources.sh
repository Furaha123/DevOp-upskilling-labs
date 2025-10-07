#!/usr/bin/env bash
set -euo pipefail

echo "=== S3 Buckets Inventory ==="

# List all buckets and extract their names
BUCKETS=$(aws s3api list-buckets --query "Buckets[].Name" --output text)

for BUCKET in $BUCKETS; do
  REGION=$(aws s3api get-bucket-location --bucket "$BUCKET" --query "LocationConstraint" --output text)

  if [[ "$REGION" == "None" || "$REGION" == "null" ]]; then
    REGION="us-east-1"
  fi

  echo "Bucket: $BUCKET | Region: $REGION"
done
