# Defined type: awsiac::instance
# ===========================
define awsiac::instance (
  $tier,
  $tier_az,
  $tier_number,
  $ensure = $::ensure,
  $instance_name = $title,
  ) {
  require awsiac

  $subnet = "${awsiac::vpc}-${tier}${tier_number}${tier_az}-sbt"
  notify { "subnet:= ${subnet}": }
}
