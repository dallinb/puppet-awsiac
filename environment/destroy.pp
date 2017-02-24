include stdlib

if $::prefix == undef {
  fail('You must specify a prefix.')
}

if $::region == undef {
  fail('You must specify a region.')
}

$vpc = regsubst(upcase("${prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')

Ec2_instance <| |> -> Ec2_securitygroup <| |>
Ec2_instance <| |> -> Ec2_vpc_subnet <| |>
Ec2_securitygroup <| |> -> Ec2_vpc <| |>
Ec2_vpc_subnet <| |> -> Ec2_vpc <| |>
Ec2_vpc_subnet <| |> -> Ec2_vpc_internet_gateway <| |>
Ec2_vpc_subnet <| |> -> Ec2_vpc_routetable <| |>
Ec2_vpc_internet_gateway <| |> -> Ec2_vpc <| |>
Ec2_vpc_routetable <| |> -> Ec2_vpc <| |>
Ec2_vpc <| |> -> Ec2_vpc_dhcp_options <| |>

ec2_vpc { $vpc:
  ensure     => absent,
  region     => $::region,
  cidr_block => '10.0.0.0/16',
}

ec2_vpc_internet_gateway { $vpc:
  ensure => absent,
  region => $::region,
  vpc    => $vpc,
}
