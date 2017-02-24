#!/bin/sh
#############################################################################
# A small script to run puppet with the detailed exit codes attribute.  In
# this case an exit code of 2 is a successful change.
#############################################################################
FACTER_REGION=$AWS_REGION puppet apply environment/apply.pp --test \
  --detailed-exitcodes
status=$?

if $status == 2; then
  exit 0
fi
