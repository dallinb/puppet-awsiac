require 'spec_helper'

describe '::awsiac::instance' do
  let(:pre_condition) do
    [
      'class aws () {}',
      'define ec2_vpc ($ensure, $dhcp_options, $region, $cidr_block, $tags) {}',
      'define ec2_instance() {}',
      'define ec2_securitygroup($ensure, $region, $vpc, $description, $ingress,
        $tags) {}',
      'define ec2_vpc_dhcp_options($ensure, $domain_name_servers, $region,
         $tags) {}',
      'define ec2_vpc_internet_gateway($ensure, $region, $vpc, $tags) {}',
      'define ec2_vpc_routetable($ensure, $region = "", $vpc, $routes = [],
         $tags = []) {}',
      'define ec2_vpc_subnet($ensure, $region, $cidr_block, $availability_zone,
        $map_public_ip_on_launch, $route_table, $vpc, $tags) {}'
    ]
  end

  context 'Create a demo node' do
    let :facts do
      {
        cidr_block: '192.168.0.0/16',
        ensure: 'present',
        region: 'eu-west-2',
        vpc_postfix: 'a',
        vpc_prefix: 'test'
      }
    end

    let :params do
      {
        tier: 'web',
        tier_az: 'a',
        tier_number: 1,
        ensure: 'present'
      }
    end

    let(:title) { 'demo-node' }

    it do
      is_expected.to have_resource_count(8)
    end
  end
end
