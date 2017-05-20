require 'spec_helper'
describe 'awsiac' do
  let(:pre_condition) do
    [
      'class aws () {}',
      'define ec2_vpc (
        $ensure,
        $region,
        $cidr_block,
        $tags) {}'
    ]
  end

  context 'with default values for all parameters' do
    it { should raise_error(Puppet::Error) }
  end

  context 'with the region set' do
    let :params do
      {
        region: 'eu-west-2',
        vpc_prefix: 'test'
      }
    end

    it { should contain_class('awsiac') }
    it { should contain_ec2_vpc('TESTEUW2') }
  end
end
