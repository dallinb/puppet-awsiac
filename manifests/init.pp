# Class: awsiac
# ===========================
class awsiac (
  $az_count   = $::az_count,
  $cidr_block = $::cidr_block,
  $ensure     = $::ensure,
  $region     = $::region,
  $vpc_prefix = $::vpc_prefix,
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

  $vpc = regsubst(upcase("${vpc_prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')

  $tags = {
    environment => downcase($vpc),
  }

  case $region {
    'eu-west-2': {
      $ntp_servers = '0.uk.pool.ntp.org,1.uk.pool.ntp.org,2.uk.pool.ntp.org,3.uk.pool.ntp.org'
    }
    default: {
      $ntp_servers = [
        '0.pool.ntp.org',
        '1.pool.ntp.org',
        '2.pool.ntp.org',
        '3.pool.ntp.org'
      ]
    }
  }

  ec2_vpc_dhcp_options { "${vpc}-dopt":
    ensure      => $ensure,
    ntp_servers => $ntp_servers,
    region      => $region,
    tags        => $tags,
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
}
