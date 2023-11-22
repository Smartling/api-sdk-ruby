require 'smartling/api'

module Smartling

  class String < Api

    def initialize(args = {})
      super(args)
      @projectId = args[:projectId]
    end

    # List Source Strings - /strings-api/v2/projects/{projectId}/source-strings
    def source_strings(params = nil)
      uri = uri("/strings-api/v2/projects/#{@projectId}/source-strings", params)
      return get(uri)
    end

  end
end
