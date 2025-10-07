#!/usr/bin/env bash
set -euo pipefail

# ----- Config -----
BASE_NAME="amalitech-devops"
REGIONS=("us-east-1" "eu-west-1" "ap-southeast-1")
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"

# ----- Create buckets across regions -----
for REGION in "${REGIONS[@]}"; do
  BUCKET_NAME="${BASE_NAME}-${REGION}-${TIMESTAMP}"

  echo "Creating bucket in ${REGION}..."
  if [[ "${REGION}" == "us-east-1" ]]; then
    aws s3api create-bucket --bucket "${BUCKET_NAME}" --region "${REGION}" >/dev/null
  else
    aws s3api create-bucket \
      --bucket "${BUCKET_NAME}" \
      --region "${REGION}" \
      --create-bucket-configuration LocationConstraint="${REGION}" >/dev/null
  fi

  aws s3api put-bucket-versioning \
    --bucket "${BUCKET_NAME}" \
    --region "${REGION}" \
    --versioning-configuration Status=Enabled >/dev/null

  echo "Bucket ${BUCKET_NAME} created successfully"
done

echo "All buckets created and versioning enabled."
