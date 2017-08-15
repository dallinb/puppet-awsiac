#!/bin/sh
#############################################################################
# A basic wrapper to allow us to call puppet with '--detailed-exitcodes' but
# still return zero when there was full success.
#
# See https://docs.puppet.com/puppet/latest/man/apply.html for more details
#############################################################################
echo "AWS_REGION        : $AWS_REGION"
echo "CIDR Block        : $FACTER_cidr_block"
echo "Puppet Environment: $PUPPET_ENVIRONMENT"
echo "VPC Prefix        : $FACTER_vpc_prefix"
echo "VPC Postfix       : $FACTER_vpc_postfix"

FACTER_region=$AWS_REGION puppet apply examples/init.pp --test \
  --environment $PUPPET_ENVIRONMENT $PUPPET_OPTS \
  --modulepath /home/ubuntu/.puppetlabs/etc/code/environments/${PUPPET_ENVIRONMENT} \
  --hiera_config hiera.yaml
status=$?
[ $status -eq 0 -o $status -eq 2 ] && exit 0
exit $status
