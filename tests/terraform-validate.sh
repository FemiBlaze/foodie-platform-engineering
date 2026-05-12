#!/bin/bash

cd infra || exit 1

terraform fmt -check
terraform validate

if [ $? -eq 0 ]; then
  echo "PASS: Terraform is valid"
else
  echo "FAIL: Terraform errors detected"
  exit 1
fi