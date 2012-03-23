require 'rest-client'
require 'multi_json'

module Smartling

  module Endpoints
    V1 = 'https://api.smartling.com/v1'
    SANDBOX_V1 = 'https://sandbox-api.smartling.com/v1'
    CURRENT = V1
    SANDBOX = SANDBOX_V1
  end

  class Api
    attr_accessor :apiKey, :projectId, :baseUrl
    def initialize(apiKey, projectId, baseUrl = nil)
      @apiKey = apiKey or raise 'Missing apiKey parameter'
      @projectId = projectId or raise 'Missing projectId parameter'
      @baseUrl = baseUrl || Endpoints::CURRENT
    end

    def uri(path, params1 = nil, params2 = nil)
      params = { :apiKey => @apiKey, :projectId => @projectId }
      params.merge!(params1) if params1
      params.merge!(params2) if params2
      uri = URI.parse(@baseUrl + path)
      uri.query = URI.respond_to?(:encode_www_form) ? URI.encode_www_form(params) : params.map {|k,v| k.to_s + "=" + URI.escape(v) }.join('&')
      return uri.to_s
    end

    def process(res)
      body = MultiJson.decode(res)
      body = body['response']

      if body['code'] != 'SUCCESS'
        raise "API error: #{body['code']} #{body['messages']}"
      end

      return body['data']
    end

    def get(uri)
      res = RestClient.get(uri)
      return process(res)
    end
    def get_raw(uri)
      return RestClient.get(uri)
    end
    def post(uri, params = nil)
      res = RestClient.post(uri, params)
      return process(res)
    end

    def log=(v)
      RestClient.log = v
    end
    def proxy=(v)
      RestClient.proxy = v
    end
  end

end

