#!/usr/bin/ruby
$:.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'test/unit'
require 'smartling'

module SmartlingTests
  class SmartlingApiTest < Test::Unit::TestCase

    def test_endpoints
      sl = Smartling::Api.new('', '')
      assert_equal(Smartling::Endpoints::CURRENT, sl.baseUrl)
      sl = Smartling::Api.new('', '', Smartling::Endpoints::V1)
      assert_equal(Smartling::Endpoints::V1, sl.baseUrl)
      sl = Smartling::Api.new('', '', Smartling::Endpoints::SANDBOX)
      assert_equal(Smartling::Endpoints::SANDBOX, sl.baseUrl)
      sl = Smartling::Api.new('', '', 'custom')
      assert_equal('custom', sl.baseUrl)
    end

    def test_response
      sl = Smartling::Api.new('', '')
      res = sl.process('{"response":{"code":"SUCCESS", "data":"foo"}}')
      assert_equal('foo', res)
    end

  end
end

