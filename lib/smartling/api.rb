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
    attr_accessor :api_key, :project_id, :base_url

    def initialize(args)
      @api_key = args[:api_key] or raise ArgumentError, 'Missing :api_key parameter'
      @project_id = args[:project_id] or raise ArgumentError, 'Missing :project_id parameter'
      @base_url = args[:base_url] || Endpoints::CURRENT
    end

    def self.sandbox(args)
      new(args.merge(:base_url => Endpoints::SANDBOX))
    end

    def uri(path, params1 = nil, params2 = nil)
      params = { :apiKey => @api_key, :projectId => @project_id }
      params.merge!(params1) if params1
      params.merge!(params2) if params2
      uri = URI.parse(@base_url + path)
      uri.query = URI.respond_to?(:encode_www_form) ? URI.encode_www_form(params) : params.map {|k,v| k.to_s + "=" + URI.escape(v) }.join('&')
      return uri.to_s
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

    def log=(v)
      RestClient.log = v
    end
    def proxy=(v)
      RestClient.proxy = v
    end
  end

end

