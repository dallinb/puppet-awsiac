#!/bin/sh
#############################################################################
# A small script to run puppet with the detailed exit codes attribute.  In
# this case an exit code of 2 is a successful change.
#############################################################################
LOGFILE=${CIRCLE_ARTIFACTS}/puppet.json

FACTER_REGION=$AWS_REGION puppet apply environment/apply.pp --test | \
  tee ${CIRCLE_ARTIFACTS}/puppet.log
status=$?

case $status in
  2) status=0 ;;
esac

exit $status
