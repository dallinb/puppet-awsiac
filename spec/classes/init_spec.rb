require 'spec_helper'
describe 'awsiac' do
  let(:pre_condition) do
    [
      'class aws () {}',
      'define ec2_vpc ($ensure, $region, $cidr_block, $tags) {}',
      'define ec2_vpc_internet_gateway($ensure, $region, $vpc, $tags) {}',
      'define ec2_vpc_routetable($ensure, $region = "", $vpc, $routes = [],
         $tags = []) {}'
    ]
  end

  context 'with default values for all parameters' do
    it { should raise_error(Puppet::Error) }
  end

  context 'Apply' do
    let :params do
      {
        ensure: 'present',
        region: 'eu-west-2',
        vpc_prefix: 'test'
      }
    end

    it { should contain_class('awsiac') }
    it { should contain_ec2_vpc('TESTEUW2') }
  end

  context 'Destroy' do
    let :params do
      {
        ensure: 'absent',
        region: 'eu-west-2',
        vpc_prefix: 'test'
      }
    end

    it { should contain_class('awsiac') }
    it { should contain_ec2_vpc('TESTEUW2') }
    it { should contain_ec2_vpc_routetable('TESTEUW2-rtb') }
    it { should contain_ec2_vpc_routetable('TESTEUW2') }
    it { should contain_ec2_vpc_internet_gateway('TESTEUW2-igw') }
  end
end
