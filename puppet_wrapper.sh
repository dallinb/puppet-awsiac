#!/bin/sh
#############################################################################
# A basic wrapper to allow us to call puppet with '--detailed-exitcodes' but
# still return zero when there was full success.
#
# See https://docs.puppet.com/puppet/latest/man/apply.html for more details
#############################################################################
puppet $*
status=$?
[ $status -eq 0 -o $status -eq 2 ] && exit 0
exit $status
