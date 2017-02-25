include stdlib

if $::prefix == undef {
  fail('You must specify a prefix.')
}

if $::region == undef {
  fail('You must specify a region.')
}

$vpc = regsubst(upcase("${prefix}${region}"), '-([A-Z]).*(\d+)$', '\1\2')
$igw = "${vpc}-igw"
$rtb = "${vpc}-rtb"

$tags = {
  environment => downcase($vpc),
}

ec2_vpc { $vpc:
  ensure     => present,
  region     => $::region,
  cidr_block => '10.0.0.0/16',
  tags       => $tags,
}

ec2_vpc_internet_gateway { $igw:
  ensure => present,
  region => $::region,
  vpc    => $vpc,
  tags   => $tags,
}

ec2_vpc_routetable { $rtb:
  ensure => present,
  region => $region,
  routes => [
    {
      destination_cidr_block => '10.0.0.0/16',
      gateway                => 'local'
    },
    {
      destination_cidr_block => '0.0.0.0/0',
      gateway                => $igw,
    },
  ],
  vpc    => $vpc,
  tags   => $tags,
}
