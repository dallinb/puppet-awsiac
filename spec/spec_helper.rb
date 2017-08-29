require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet'
require 'rspec-puppet-utils'

RSpec.configure do |config|
  config.mock_with :rspec
  config.raise_errors_for_deprecations!

  config.before(:each) do
    MockFunction.new('concat') do |f|
      f.stubbed.with([], 'TESTEUW1-app1a-sbt').returns(['TESTEUW1-app1a-sbt'])
      f.stubbed.with([], 'TESTEUW1-app1b-sbt').returns(['TESTEUW1-app1b-sbt'])
      f.stubbed.with([], 'TESTEUW1-app1c-sbt').returns(['TESTEUW1-app1c-sbt'])
      f.stubbed.with([], 'TESTEUW1-db1a-sbt').returns(['TESTEUW1-db1a-sbt'])
      f.stubbed.with([], 'TESTEUW1-db1b-sbt').returns(['TESTEUW1-db1b-sbt'])
      f.stubbed.with([], 'TESTEUW1-db1c-sbt').returns(['TESTEUW1-db1c-sbt'])
      f.stubbed.with([], 'TESTEUW1-web1a-sbt').returns(['TESTEUW1-web1a-sbt'])
      f.stubbed.with([], 'TESTEUW1-web1b-sbt').returns(['TESTEUW1-web1b-sbt'])
      f.stubbed.with([], 'TESTEUW1-web1c-sbt').returns(['TESTEUW1-web1c-sbt'])
      f.stubbed.with([], 'TESTEUW2-app1a-sbt').returns(['TESTEUW2-app1a-sbt'])
      f.stubbed.with([], 'TESTEUW2-app1b-sbt').returns(['TESTEUW2-app1b-sbt'])
      f.stubbed.with([], 'TESTEUW2-db1a-sbt').returns(['TESTEUW2-db1a-sbt'])
      f.stubbed.with([], 'TESTEUW2-db1b-sbt').returns(['TESTEUW2-db1b-sbt'])
      f.stubbed.with([], 'TESTEUW2-web1a-sbt').returns(['TESTEUW2-web1a-sbt'])
      f.stubbed.with([], 'TESTEUW2-web1b-sbt').returns(['TESTEUW2-web1b-sbt'])
    end

    MockFunction.new('downcase') do |f|
      f.stubbed.with('TESTEUW1').returns('testeuw1')
      f.stubbed.with('TESTEUW2').returns('testeuw2')
    end

    MockFunction.new('load_module_metadata') do |f|
      f.stubbed.with('awsiac').returns('version' => 42)
    end

    MockFunction.new('upcase') do |f|
      f.stubbed.with('testeu-west-1').returns('TESTEU-WEST-1')
      f.stubbed.with('testeu-west-2').returns('TESTEU-WEST-2')
    end
  end

  config.after(:suite) do
    exit(1) if RSpec::Puppet::Coverage.report!(100)
  end
end
