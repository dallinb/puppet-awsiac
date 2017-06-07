require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-utils'

RSpec.configure do |config|
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.before(:each) do
    MockFunction.new('downcase') do |f|
      f.stubbed.with('TESTEUW2A').returns('testeuw2a')
    end

    MockFunction.new('upcase') do |f|
      f.stubbed.with('testeu-west-2a').returns('TESTEU-WEST-2A')
    end
  end

  config.after(:suite) do
    exit(1) if RSpec::Puppet::Coverage.report!(100)
  end
end
