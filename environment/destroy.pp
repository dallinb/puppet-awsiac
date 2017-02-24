include stdlib

if $::prefix == undef {
  fail('You must specify a prefix.')
}

if $::region == undef {
  fail('You must specify a region.')
}

$vpc = regsubst(upcase("${prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')

ec2_vpc_internet_gateway { $vpc:
  ensure => absent,
  region => $::region,
  vpc    => $vpc,
}

ec2_vpc_routetable { $vpc:
  ensure => absent,
  region => $region,
  routes => [
    {
      destination_cidr_block => '0.0.0.0/0',
      gateway                => "${::environment}-igw",
    },
    {
      destination_cidr_block => '10.0.0.0/16',
      gateway                => 'local'
    },
  ],
  vpc    => $vpc,
} ->
ec2_vpc { $vpc:
  ensure     => absent,
  region     => $::region,
  cidr_block => '10.0.0.0/16',
}

