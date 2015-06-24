#!/usr/bin/ruby
# Copyright 2012 Smartling, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

$:.unshift File.expand_path('../', __FILE__)
require 'test_helper'

module SmartlingTests
  class SmartlingApiTest < Test::Unit::TestCase

    def stub_response(code, body)
      status = Net::HTTPResponse.new('', code, '')
      if RestClient::Response.method(:create).arity > 3
          RestClient::Response.create(body, status, {}, nil)
      else
          RestClient::Response.create(body, status, {})
      end
    end

    def test_endpoints
      sl = Smartling::Api.new()
      assert_equal(Smartling::Endpoints::CURRENT, sl.baseUrl)

      sl = Smartling::Api.new(:baseUrl => Smartling::Endpoints::V1)
      assert_equal(Smartling::Endpoints::V1, sl.baseUrl)

      sl = Smartling::Api.new(:baseUrl => Smartling::Endpoints::SANDBOX)
      assert_equal(Smartling::Endpoints::SANDBOX, sl.baseUrl)

      sl = Smartling::Api.sandbox()
      assert_equal(Smartling::Endpoints::SANDBOX, sl.baseUrl)

      sl = Smartling::Api.new(:baseUrl => 'custom')
      assert_equal('custom', sl.baseUrl)
    end

    def test_response_format
      sl = Smartling::Api.new()

      res = stub_response(200, '{"response":{"code":"SUCCESS", "data":"foo"}}')
      assert_equal('foo', sl.process(res))

      res = stub_response(200, '{"response":{"code":"SUCCESS", "data":null}}')
      res = sl.process(res)
      assert(res.nil?)

    end

    def test_error_response
      sl = Smartling::Api.new()

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
