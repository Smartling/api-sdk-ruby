#!/usr/bin/ruby
require 'tests/test_helper.rb'

module SmartlingTests
  class SmartlingUriTest < Test::Unit::TestCase

    def test_base
      uri = Smartling::Uri.new('http://hello.wo/')
      assert_equal('http://hello.wo/?', uri.to_s)

      uri = Smartling::Uri.new('http://hello.wo/', 'foo/bar')
      assert_equal('http://hello.wo/foo/bar?', uri.to_s)
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
      assert_equal('http://hello.wo/?', uri.to_s)
    end

  end
end

