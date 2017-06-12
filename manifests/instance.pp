# Defined type: awsiac::instance
# ===========================
define awsiac::instance (
  $tier,
  $tier_az,
  $tier_number,
  $ensure = $::ensure,
  $instance_name = $title,
  ) {
  include awsiac

  $subnet = "${awsiac::vpc}-${tier}${tier_number}${tier_az}-sbt"
  notify { "subnet:= ${subnet}": }
}
