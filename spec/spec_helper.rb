require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-utils'

RSpec.configure do |config|
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.after(:suite) do
    exit(1) if RSpec::Puppet::Coverage.report!(100)
  end
end
