# Class: awsiac
# ===========================
class awsiac (
  $region,
  $cidr_block  = $::cidr_block,
  $ensure      = $::ensure,
  $vpc_postfix = $::vpc_postfix,
  $vpc_prefix  = $::vpc_prefix,
  ){
  # Reverse the default resource ordering if the resources are to be 'absent'.
  if $ensure == 'absent' {
    Ec2_instance <| |> -> Ec2_securitygroup <| |>
    Ec2_instance <| |> -> Ec2_vpc_subnet <| |>
    Ec2_securitygroup <| |> -> Ec2_vpc <| |>
    Ec2_vpc_subnet <| |> -> Ec2_vpc <| |>
    Ec2_vpc_subnet <| |> -> Ec2_vpc_internet_gateway <| |>
    Ec2_vpc_subnet <| |> -> Ec2_vpc_routetable <| |>
    Ec2_vpc_internet_gateway <| |> -> Ec2_vpc <| |>
    Ec2_vpc_routetable <| |> -> Ec2_vpc <| |>
    Ec2_vpc <| |> -> Ec2_vpc_dhcp_options <| |>
  }

  $regsubst_target = upcase("${vpc_prefix}${region}${vpc_postfix}")
  $regsubst_regexp = "-([A-Z]).*(\\d+)(${vpc_postfix})$"
  $vpc = regsubst($regsubst_target, $regsubst_regexp, '\1\2\3', 'I')
  $first2octets = regsubst($cidr_block,'^(\d+)\.(\d+)\.(\d+)\.(\d+)/(\d+)$','\1.\2')

  $tags = {
    environment => downcase($vpc),
  }

  ec2_vpc_dhcp_options { "${vpc}-dopt":
    ensure              => $ensure,
    domain_name         => 'locp.co.uk',
    domain_name_servers => ['8.8.8.8', '8.8.4.4'],
    region              => $region,
    tags                => $tags,
  }

  ec2_vpc { $vpc:
    ensure       => $ensure,
    cidr_block   => $cidr_block,
    dhcp_options => "${vpc}-dopt",
    region       => $region,
    tags         => $tags,
  }

  ec2_vpc_internet_gateway { "${vpc}-igw":
    ensure => $ensure,
    region => $region,
    vpc    => $vpc,
    tags   => $tags,
  }

  ec2_vpc_routetable { "${vpc}-rtb":
    ensure => $ensure,
    region => $region,
    vpc    => $vpc,
    tags   => $tags,
    routes => [
      {
        destination_cidr_block => $cidr_block,
        gateway                => 'local'
      },{
        destination_cidr_block => '0.0.0.0/0',
        gateway                => "${vpc}-igw"
      },
    ],
  }

  ec2_vpc_subnet { "${vpc}-web1a-sbt":
    ensure                  => $ensure,
    region                  => $region,
    cidr_block              => "${first2octets}.0.0/24",
    availability_zone       => "${region}a",
    map_public_ip_on_launch => true,
    route_table             => "${vpc}-rtb",
    vpc                     => $vpc,
    tags                    => $tags,
  }

  ec2_securitygroup { "${vpc}-odoo-sg":
    ensure      => $ensure,
    region      => $region,
    vpc         => $vpc,
    description => 'Security group for the odoo role',
    ingress     => [
      {
        protocol => 'tcp',
        port     => 22,
        cidr     => '0.0.0.0/0',
      }, {
        protocol => 'tcp',
        port     => 80,
        cidr     => '0.0.0.0/0',
      }, {
        protocol => 'tcp',
        port     => 443,
        cidr     => '0.0.0.0/0',
      }
    ],
    tags        => $tags,
  }

  ec2_instance { "${vpc}:odoo1a":
    ensure                    => $ensure,
    region                    => $region,
    availability_zone         => "${region}a",
    iam_instance_profile_name => 'puppet',
    image_id                  => 'ami-785db401',
    instance_type             => 't2.micro',
    key_name                  => 'puppet',
    subnet                    => "${vpc}-web1a-sbt",
    security_groups           => ["${vpc}-odoo-sg"],
    tags                      => $tags,
    user_data                 => template('awsiac/userdata.erb'),
  }
}
