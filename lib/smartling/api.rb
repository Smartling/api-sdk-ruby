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

require 'rest-client'
require 'multi_json'
require 'smartling/uri'

module Smartling

  module Endpoints
    CURRENT = 'https://api.smartling.com/'
    SANDBOX = 'https://sandbox-api.smartling.com/'
  end

  class Api
    attr_accessor :baseUrl, :prefix

    def initialize(args = {})
      @userId = args[:userId]
      @userSecret = args[:userSecret]

      @baseUrl = args[:baseUrl] || Endpoints::CURRENT
      @prefix = ''
    end

    def self.sandbox(args = {})
      new(args.merge(:baseUrl => Endpoints::SANDBOX))
    end

    def uri(path, params1 = nil, params2 = nil)
      uri = Uri.new(@baseUrl, prefix, path)
      params = {}
      params.merge!(params1) if params1
      params.merge!(params2) if params2
      uri.params = params
      return uri
    end

    def check_response(res)
      return if res.code == 200
      raise format_api_error(res.body)
    end

    def process(res)
      check_response(res)
      body = MultiJson.decode(res.body)
      body = body['response']
      raise format_api_error(res.body) unless body && body['code'] == 'SUCCESS'
      return body['data']
    end

    def format_api_error(res)
      begin
        body = MultiJson.decode(res.body)
      rescue
      end
      body = body['response'] if body
      code = body['code'] if body
      msg = body['messages'] if body
      msg = msg.join(' -- ') if msg.is_a?(Array)
      return "API error: #{code} #{msg}" if code
      return res.description
    end

    def get(uri)
      RestClient.get(uri, token_header()) {|res, _, _|
        process(res)
      }
    end
    def get_raw(uri)
      RestClient.get(uri, token_header()) {|res, _, _|
        check_response(res)
        res.body
      }
    end
    def post(uri, params = nil)
      RestClient.post(uri, params, token_header()) {|res, _, _|
        process(res)
      }
    end

    def log=(v)
      RestClient.log = v
    end
    def proxy=(v)
      RestClient.proxy = v
    end

    # auth

    def token_header()
      t = token()
      raise "Authentication error" unless t
      return {:Authorization => 'Bearer ' + t}
    end

    def process_auth(response) 
      now = Time.new.to_i
      @token = response[:accessToken]
      @token_expiration = now + response[:expiresIn]
      @refresh = response[:refreshToken]
      @refresh_expiration = now + response[:refreshExpiresIn]
    end

    # Authenticate - /auth-api/v2/authenticate (POST)
    def token()
      # Check if current token is still valid
      if @token
        now = Time.new.to_i
        if @token_expiration > now
          return @token
        elsif @refresh && @refresh_expiration > now
          return refresh()
        end
      end

      # Otherwise call authenticate endpoint
      uri = uri('auth-api/v2/authenticate', {}, {})
      RestClient.post(uri, {:userId => @userId, :userSecret => @userSecret}) {|res, _, _|
        process_auth(process(res))
        return @token
      }
    end

    # Refresh Authentication - /auth-api/v2/authenticate/refresh (POST)
    def refresh()
      uri = uri('auth-api/v2/authenticate/refresh', {}, {})
      RestClient.post(uri, {:refreshToken => @refreshToken}) {|res, _, _|
        process_auth(process(res))
        return @token
      }
    end

  end

end

