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
    V1 = 'https://api.smartling.com/v1/'
    SANDBOX_V1 = 'https://sandbox-api.smartling.com/v1/'
    CURRENT = V1
    SANDBOX = SANDBOX_V1
  end

  class Api
    attr_accessor :apiKey, :projectId, :baseUrl

    def initialize(args = {})
      @apiKey = args[:apiKey]
      @projectId = args[:projectId]
      @baseUrl = args[:baseUrl] || Endpoints::CURRENT
    end

    def self.sandbox(args = {})
      new(args.merge(:baseUrl => Endpoints::SANDBOX))
    end

    def uri(path, params1 = nil, params2 = nil)
      uri = Uri.new(@baseUrl, path)
      params = { :apiKey => @apiKey, :projectId => @projectId }
      params.merge!(params1) if params1
      params.merge!(params2) if params2
      uri.params = params
      uri.require(:apiKey, :projectId)
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
      RestClient.get(uri) {|res, _, _|
        process(res)
      }
    end
    def get_raw(uri)
      RestClient.get(uri) {|res, _, _|
        check_response(res)
        res.body
      }
    end
    def post(uri, params = nil)
      RestClient.post(uri, params) {|res, _, _|
        process(res)
      }
    end
    def delete(uri)
      RestClient.delete(uri) {|res, _, _|
        process(res)
      }
    end

    def log=(v)
      RestClient.log = v
    end
    def proxy=(v)
      RestClient.proxy = v
    end
  end

end

