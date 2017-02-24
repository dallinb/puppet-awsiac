include stdlib

if $::prefix == undef {
  fail('You must specify a prefix.')
}

if $::region == undef {
  fail('You must specify a region.')
}

$vpc = regsubst(upcase("${prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')

$tags = {
  environment => $vpc,
}

ec2_vpc { $vpc:
  ensure     => present,
  region     => $::region,
  cidr_block => '10.0.0.0/16',
  tags       => $tags,
}

ec2_vpc_internet_gateway { $vpc:
  ensure => present,
  region => $::region,
  vpc    => $vpc,
  tags   => $tags,
}

ec2_vpc_routetable { $vpc:
  ensure => present,
  region => $region,
  routes => [
    {
      destination_cidr_block => '0.0.0.0/0',
      gateway                => $vpc,
    },
    {
      destination_cidr_block => '10.0.0.0/16',
      gateway                => 'local'
    },
  ],
  vpc    => $vpc,
  tags   => $tags,
}
