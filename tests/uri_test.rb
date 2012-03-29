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
  class SmartlingUriTest < Test::Unit::TestCase

    def test_base
      uri = Smartling::Uri.new('http://hello.wo/')
      assert_equal('http://hello.wo/', uri.to_s)

      uri = Smartling::Uri.new('http://hello.wo/', 'foo/bar')
      assert_equal('http://hello.wo/foo/bar', uri.to_s)
    end

    def test_require
      uri = Smartling::Uri.new('http://hello.wo/')
      uri.require(:foo, :bar)
      assert_raise ArgumentError do uri.to_s end

      uri = Smartling::Uri.new('http://hello.wo/')
      uri.params = {:foo => 'x', :bar => 'y'}
      uri.require(:foo, :bar)
      assert_nothing_raised do uri.to_s end

      uri = Smartling::Uri.new('http://hello.wo/')
      uri.params = {:foo => 'x', :baz => 'z'}
      uri.require(:foo, :bar)
      assert_raise ArgumentError do uri.to_s end

      uri = Smartling::Uri.new('http://hello.wo/')
      uri.params = {:bar => 'y', :baz => 'z', :foo => 'x'}
      uri.require(:foo, :baz)
      assert_nothing_raised do uri.to_s end

      uri = Smartling::Uri.new('http://hello.wo/')
      uri.require()
      assert_nothing_raised do uri.to_s end
      assert_equal('http://hello.wo/', uri.to_s)
    end

  end
end

