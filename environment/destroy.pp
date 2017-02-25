include stdlib

if $::prefix == undef {
  fail('You must specify a prefix.')
}

if $::region == undef {
  fail('You must specify a region.')
}

Ec2_vpc_internet_gateway <| |> -> Ec2_vpc <| |>
Ec2_vpc_routetable <| |> -> Ec2_vpc <| |>

$vpc = regsubst(upcase("${prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')
$igw = "${vpc}-igw"
$rtb = "${vpc}-rtb"

ec2_vpc_internet_gateway { $igw:
  ensure => absent,
  region => $::region,
  vpc    => $vpc,
}

ec2_vpc_routetable { $rtb:
  ensure => absent,
  region => $::region,
  vpc    => $vpc,
}

ec2_vpc { $vpc:
  ensure     => absent,
  region     => $::region,
  cidr_block => '10.0.0.0/16',
}
