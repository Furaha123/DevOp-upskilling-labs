#!/usr/bin/env bash
# Automated AWS Security Audit Script
# Checks S3 bucket security, IAM security, CloudTrail, VPC Flow Logs, and Security Groups
# Outputs results to the console and saves IAM credential report to credential-report.csv

set -u -o pipefail 

ISSUES=0
PROFILE_ARG=${AWS_PROFILE:+--profile "$AWS_PROFILE"}
REGION_ARG=${AWS_REGION:+--region "$AWS_REGION"}

line() { printf '%s\n' "------------------------------------------------------------"; }
pass() { printf "  ✓ %s\n" "$1"; }
fail() { printf "  ⚠ %s\n" "$1"; ISSUES=$((ISSUES+1)); }
title() { printf "\n%s\n" "$1"; line; }

aws_safe() {
  aws $PROFILE_ARG $REGION_ARG "$@" 2>/dev/null
}

# =========================
# 1) S3 BUCKET SECURITY
# =========================
title "S3 Bucket Security"

BUCKETS=$(aws_safe s3api list-buckets --query 'Buckets[].Name' --output text)
if [[ -z "${BUCKETS// }" ]]; then
  pass "No S3 buckets found (nothing to check)."
else
  for B in $BUCKETS; do
    printf "Bucket: %s\n" "$B"

    if aws_safe s3api get-public-access-block --bucket "$B" >/dev/null; then
   
      pass "Public Access Block is configured."
    else
      fail "Public Access Block NOT configured."
    fi

    if aws_safe s3api get-bucket-encryption --bucket "$B" >/dev/null; then
      pass "Default encryption is ENABLED."
    else
      fail "Default encryption is NOT configured."
    fi
  done
fi

# =========================
# 2) IAM SECURITY (ACCOUNT)
# =========================
title "IAM Security (Account-Level)"

# Root MFA enabled?
ROOT_MFA=$(aws_safe iam get-account-summary --query 'SummaryMap.AccountMFAEnabled' --output text || echo "0")
if [[ "$ROOT_MFA" == "1" ]]; then
  pass "Root account MFA is ENABLED."
else
  fail "Root account MFA is NOT enabled."
fi

if aws_safe iam get-account-password-policy >/dev/null; then
  pass "Account password policy is CONFIGURED."
else
  fail "Account password policy is NOT configured."
fi

printf "Generating IAM credential report..."
if aws_safe iam generate-credential-report >/dev/null; then
  sleep 2
  if aws_safe iam get-credential-report --query 'Content' --output text | base64 --decode > credential-report.csv 2>/dev/null; then
    printf " done.\n"
    pass "Credential report generated and saved to credential-report.csv."
  else
    printf " failed.\n"
    fail "Could not download credential report."
  fi
else
  printf " failed.\n"
  fail "Could not generate credential report."
fi

# ==================================
# 3) ADDITIONAL CHECKS (at least 2)
# ==================================

title "CloudTrail"

TRAILS=$(aws_safe cloudtrail describe-trails --query 'trailList[].Name' --output text)
if [[ -z "${TRAILS// }" ]]; then
  fail "No CloudTrail trails found."
else
  LOGGING_OK=0
  for T in $TRAILS; do
    STATUS=$(aws_safe cloudtrail get-trail-status --name "$T" --query 'IsLogging' --output text || echo "false")
    if [[ "$STATUS" == "True" || "$STATUS" == "true" ]]; then
      LOGGING_OK=1
      break
    fi
  done
  if [[ "$LOGGING_OK" -eq 1 ]]; then
    pass "At least one CloudTrail trail is actively LOGGING."
  else
    fail "CloudTrail trails exist but none are actively logging."
  fi
fi

title "VPC Flow Logs"

VPCS=$(aws_safe ec2 describe-vpcs --query 'Vpcs[].VpcId' --output text)
if [[ -z "${VPCS// }" ]]; then
  pass "No VPCs found (nothing to check)."
else
  ANY_FLOW=0
  for V in $VPCS; do
    COUNT=$(aws_safe ec2 describe-flow-logs --filter Name=resource-id,Values="$V" \
            --query 'length(FlowLogs)' --output text || echo "0")
    if [[ "$COUNT" -gt 0 ]]; then
      ANY_FLOW=1
      break
    fi
  done
  if [[ "$ANY_FLOW" -eq 1 ]]; then
    pass "At least one VPC has Flow Logs ENABLED."
  else
    fail "No VPC Flow Logs found. Enable for at least key VPCs."
  fi
fi

title "Security Groups (Overly Permissive Ingress)"

OPEN_V4=$(aws_safe ec2 describe-security-groups \
  --query "SecurityGroups[?IpPermissions[?IpRanges[?CidrIp=='0.0.0.0/0']]].[GroupId,GroupName]" \
  --output text)
OPEN_V6=$(aws_safe ec2 describe-security-groups \
  --query "SecurityGroups[?IpPermissions[?Ipv6Ranges[?CidrIpv6=='::/0']]].[GroupId,GroupName]" \
  --output text)

if [[ -z "${OPEN_V4// }" && -z "${OPEN_V6// }" ]]; then
  pass "No security groups with wide-open inbound (0.0.0.0/0 or ::/0)."
else
  fail "Found security groups with overly permissive inbound rules:"
  [[ -n "${OPEN_V4// }" ]] && printf "    (IPv4) %s\n" "$OPEN_V4"
  [[ -n "${OPEN_V6// }" ]] && printf "    (IPv6) %s\n" "$OPEN_V6"
fi

# =========================
# SUMMARY
# =========================
line
if [[ "$ISSUES" -eq 0 ]]; then
  printf "✅ Security audit completed: NO issues found.\n"
else
  printf "❗ Security audit completed: %d issue(s) found.\n" "$ISSUES"
fi
line
