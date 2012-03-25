
module Smartling
  class Uri
    attr_accessor :base,  :path, :params, :required

    def initialize(base, path = nil)
      @base = base
      @path = path
      @required = []
    end

    def require(*args)
      @required += args
      return self
    end

    def to_uri
      params = @params || {}
      required = @required || []
      params.delete_if {|k,v| v.nil? || v.to_s.size <= 0 }
      missing = required - params.keys
      raise ArgumentError, "Missing parameters: " + missing.inspect if missing.size > 0

      uri = URI.parse(@base)
      uri.merge!(@path) if @path
      uri.query = URI.respond_to?(:encode_www_form) ? URI.encode_www_form(params) : params.map {|k,v| k.to_s + "=" + URI.escape(v) }.join('&')
      return uri
    end

    def to_s
      to_uri.to_s
    end

  end
end

