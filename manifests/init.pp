# Class: awsiac
# ===========================
class awsiac (
  $region,
  $vpc_prefix,
  $ensure,
  $cidr_block = '172.16.0.0/12',
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

  ec2_vpc { $vpc:
    ensure     => $ensure,
    region     => $region,
    cidr_block => '10.0.0.0/16',
    tags       => $tags,
  }

  ec2_vpc_internet_gateway { "${vpc}-igw":
    ensure => $ensure,
    region => $region,
    vpc    => $vpc,
    tags   => $tags,
  }

  ec2_vpc_routetable { "${vpc}-rtb":
    ensure => present,
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

  # Remove the automatically created rtb.
  ec2_vpc_routetable { $vpc:
    ensure => absent,
    vpc    => $vpc,
  }
}
