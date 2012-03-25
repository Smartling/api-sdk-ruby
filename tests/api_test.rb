#!/usr/bin/ruby
$:.unshift File.expand_path('../../lib', __FILE__)
require 'rubygems'
require 'test/unit'
require 'smartling'

module SmartlingTests
  class SmartlingApiTest < Test::Unit::TestCase

    def stub_response(code, body)
      status = Net::HTTPResponse.new('', code, '')
      RestClient::Response.create(body, status, {})
    end

    def test_endpoints
      sl = Smartling::Api.new(:api_key => '', :project_id => '')
      assert_equal(Smartling::Endpoints::CURRENT, sl.base_url)

      sl = Smartling::Api.new(:api_key => '', :project_id => '', :base_url => Smartling::Endpoints::V1)
      assert_equal(Smartling::Endpoints::V1, sl.base_url)

      sl = Smartling::Api.new(:api_key => '', :project_id => '', :base_url => Smartling::Endpoints::SANDBOX)
      assert_equal(Smartling::Endpoints::SANDBOX, sl.base_url)

      sl = Smartling::Api.sandbox(:api_key => '', :project_id => '')
      assert_equal(Smartling::Endpoints::SANDBOX, sl.base_url)

      sl = Smartling::Api.new(:api_key => '', :project_id => '', :base_url => 'custom')
      assert_equal('custom', sl.base_url)
    end

    def test_response_format
      sl = Smartling::Api.new(:api_key => '', :project_id => '')

      res = stub_response(200, '{"response":{"code":"SUCCESS", "data":"foo"}}')
      assert_equal('foo', sl.process(res))

      res = stub_response(200, '{"response":{"code":"SUCCESS", "data":null}}')
      res = sl.process(res)
      assert(res.nil?)

    end

    def test_error_response
      sl = Smartling::Api.new(:api_key => '', :project_id => '')

      res = stub_response(200, '{"response":{"code":"SUCCESS", "data":"foo"}}')
      assert_equal('foo', sl.process(res))

      res = stub_response(200, '{"response":{"code":"ERROR", "messages":[]}}')
      assert_raise RuntimeError do sl.process(res) end

      res = stub_response(500, '{"response":{"code":"ERROR", "messages":[]}}')
      assert_raise RuntimeError do sl.process(res) end

      res = stub_response(500, '{"response":{"code":"ERROR"}}')
      assert_raise RuntimeError do sl.process(res) end

      res = stub_response(500, '{"response":null}')
      assert_raise RuntimeError do sl.process(res) end

      res = stub_response(500, '{}')
      assert_raise RuntimeError do sl.process(res) end

      res = stub_response(200, '{}')
      assert_raise RuntimeError do sl.process(res) end
    end

  end
end

