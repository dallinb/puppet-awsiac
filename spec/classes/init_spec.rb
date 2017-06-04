require 'spec_helper'
describe 'awsiac' do
  let(:pre_condition) do
    [
      'class aws () {}',
      'define ec2_vpc ($ensure, $dhcp_options, $region, $cidr_block, $tags) {}',
      'define ec2_instance() {}',
      'define ec2_securitygroup() {}',
      'define ec2_vpc_dhcp_options($ensure, $ntp_servers, $region, $tags) {}',
      'define ec2_vpc_internet_gateway($ensure, $region, $vpc, $tags) {}',
      'define ec2_vpc_routetable($ensure, $region = "", $vpc, $routes = [],
         $tags = []) {}',
      'define ec2_vpc_subnet() {}'
    ]
  end

  context 'with default values for all parameters' do
    it { should raise_error(Puppet::Error) }
  end

  context 'Apply' do
    let :params do
      {
        az_count: 2,
        ensure: 'present',
        region: 'eu-west-2',
        vpc_prefix: 'test',
        cidr_block: '192.168.0.0/16'
      }
    end

    it { should contain_class('awsiac') }
    it { should contain_ec2_vpc_dhcp_options('TESTEUW2-dopt') }
    it { should contain_ec2_vpc('TESTEUW2') }
    it { should contain_ec2_vpc_routetable('TESTEUW2-rtb') }
    it { should contain_ec2_vpc_internet_gateway('TESTEUW2-igw') }
  end

  context 'Destroy' do
    let :params do
      {
        az_count: 3,
        ensure: 'absent',
        region: 'eu-west-2',
        vpc_prefix: 'test',
        cidr_block: '192.168.0.0/16'
      }
    end

    it { should contain_class('awsiac') }
    it { should contain_ec2_vpc_dhcp_options('TESTEUW2-dopt') }
    it { should contain_ec2_vpc('TESTEUW2') }
    it { should contain_ec2_vpc_routetable('TESTEUW2-rtb') }
    it { should contain_ec2_vpc_internet_gateway('TESTEUW2-igw') }
  end
end
