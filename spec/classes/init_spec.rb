require 'spec_helper'
describe 'awsiac' do
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

  context 'with default values for all parameters' do
    it { should raise_error(Puppet::Error) }
  end

  context 'Apply' do
    let :params do
      {
        cidr_block: '10.42.0.0/16',
        ensure: 'present',
        region: 'eu-west-2',
        vpc_prefix: 'test'
      }
    end

    it { is_expected.to have_resource_count(6) }

    it {
      should contain_class('awsiac').with(
        cidr_block: '10.42.0.0/16',
        ensure: 'present',
        region: 'eu-west-2',
        vpc_prefix: 'test'
      )
    }

    it {
      should contain_ec2_vpc_dhcp_options('TESTEUW2-dopt').with(
        ensure: 'present',
        domain_name_servers: ['8.8.8.8', '8.8.4.4'],
        region: 'eu-west-2',
        tags: {
          'environment' => 'testeuw2'
        }
      )
    }

    it {
      should contain_ec2_vpc('TESTEUW2').with(
        ensure: 'present',
        cidr_block: '10.42.0.0/16',
        dhcp_options: 'TESTEUW2-dopt',
        region: 'eu-west-2',
        tags: {
          'environment' => 'testeuw2'
        }
      )
    }

    it {
      should contain_ec2_vpc_routetable('TESTEUW2-rtb').with(
        ensure: 'present',
        region: 'eu-west-2',
        vpc: 'TESTEUW2',
        tags: {
          'environment' => 'testeuw2'
        },
        routes: [
          {
            'destination_cidr_block' => '10.42.0.0/16',
            'gateway'                => 'local'
          }, {
            'destination_cidr_block' => '0.0.0.0/0',
            'gateway'                => 'TESTEUW2-igw'
          }
        ]
      )
    }

    it {
      should contain_ec2_vpc_internet_gateway('TESTEUW2-igw').with(
        ensure: 'present',
        region: 'eu-west-2',
        vpc: 'TESTEUW2',
        tags: {
          'environment' => 'testeuw2'
        }
      )
    }

    it { should contain_ec2_vpc_subnet('TESTEUW2-web1a-sbt') }
    it { should contain_ec2_securitygroup('TESTEUW2-odoo-sg') }
  end
end
