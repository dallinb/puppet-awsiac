#!/bin/sh
#############################################################################
# A small script to run puppet with the detailed exit codes attribute.  In
# this case an exit code of 2 is a successful change.
#############################################################################
FACTER_REGION=$AWS_REGION puppet apply environment/apply.pp --test
status=$?

case $status in
  2) status=0 ;;
esac

cp /home/ubuntu/.puppetlabs/opt/puppet/cache/state/state.yaml \
  $CIRCLE_ARTIFACTS
exit $status
